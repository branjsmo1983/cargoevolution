use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
use Path::Class;
use DBI;
use Date::Simple ('date', 'today');

require "../cgi-bin/italia.pl";
require "../cgi-bin/generateHTMLSelectorRegionIT.pl";
require "../cgi-bin/generateHTMLSelectorProvinceIT.pl";
require "../cgi-bin/american2EuropeanData.pl";
require "../cgi-bin/getVeihcleType.pl";
require "../cgi-bin/generateContactButton.pl";
require "../cgi-bin/generateHTMLChatCombo.pl";
require "../cgi-bin/getFeedbackFromUserID.pl";
require "../cgi-bin/generateHTMLFooter.pl";
require "../cgi-bin/generateHTMLopenTag.pl";
require "../cgi-bin/generateHTMLheader.pl";
require "../cgi-bin/isNull2Integer.pl";
require "../cgi-bin/generateWriteButton.pl";
require "../cgi-bin/getLinkToTempHTML.pl";
require "../cgi-bin/getSentEmailText.pl";
require "../cgi-bin/getEmailFromUserID.pl";
require "../cgi-bin/getVehicleDetails.pl";
require "../cgi-bin/checkIfUserOnlineFromMid.pl";
require "../cgi-bin/generateHTMLRefreshImage.pl";
require "../cgi-bin/getNumUnreadMessagesTrip.pl";
require "../cgi-bin/getCompanyDataFromUserID.pl";

sub generateHTMLResultTable{

my $sth=$_[0];
my $sid=$_[1];
my $print_Contact=$_[2];
my $page_num=$_[3]; # starting from 0

my $N_tot = $sth->rows;
my $mess_per_page=10;

if( !$page_num )
{
   $page_num = 0;
}

#get ID from User Session
$session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $ID = $session->param("username");
my $last_action = $session->param("last_action");
my $new_token= rand(10000000);
$session->param("token", "$new_token");
$session->param("token_face1", "$new_token");


# print "\$last_action = $last_action\n";
#my $tmp = $session->param("pgcommand");
#print "\$tmp = $tmp\n";

print <<EOF;
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 5.0 Final//IT" >
EOF

my $addtional_tags = '';
my $pingUserToReply = "False"; # TODO, this will be superseeded by the on site chat
my $count=0;
my $cnt_pop=0;

generateHTMLopenTag();
generateHTMLheader("Cargoevolution", $addtional_tags);


print "<body translate=\"no\" >\n";
print "<header>\n";
if( $print_Contact ne "viewOnly" )
{
   if( $print_Contact ne "Requests" )
   {
     print "<h1>Annunci</h1>\n";
     print "</header>\n";
     my $image=generateHTMLRefreshImage();
     print "<p>\n<a href=\"generateHTMLHome.pl?sid=$sid\">Clicca qui per tornare Indietro</a>\n<a href=\"goBackSearch.pl?sid=$sid&page_num=$page_num\">$image</a></p>\n";
   }
   else
   {
     print "<h1>Trasportatori Contattati</h1>\n";
     $pingUserToReply = "True";
     print "</header>\n";
     my $image=generateHTMLRefreshImage();
     print "<p>\n<a href=\"generateHTMLHome.pl?sid=$sid\">Clicca qui per tornare Indietro</a>\n<a href=\"selectUserContactRequests.pl?sid=$sid&page_num=$page_num\">$image</a></p>\n";
   }

}
else
{
   print "<h1>I miei viaggi</h1>\n";
   print "</header>\n";
   my $image=generateHTMLRefreshImage();
   print "<p>\n<a href=\"generateHTMLHome.pl?sid=$sid\">Clicca qui per tornare Indietro</a>\n<a href=\"selectUserMessages.pl?sid=$sid&page_num=$page_num\">$image</a></p>\n";
}
print <<EOF;
<div class="panel panel-primary" style="margin:20px;">
<div class="panel-heading">
<h3 class="panel-title">

</h3>
</div>

<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<div class="panel-body">
<input type="hidden" id="sid" name="sid" value="$sid">
EOF

if( $print_Contact eq "viewOnly" )
{
  print "<table id=\"resultTable\" name=\"resultTable\" class=\"result\"  style=\"display:none\" >\n";
}
else
{
  print "<table id=\"resultTable\" name=\"resultTable\" class=\"result\"  >\n";
}

# print <<EOF;
#     <script src="/hideTable.js"> </script>
# EOF
    # separate on commas, i.e.:
    #28, 1, 1, 2017-02-08 15:26:58, 2017-02-12, 2017-02-12, Italy, Abruzzo, LAquila, Abruzzo, Teramo, 2, , 0
    print "<thead>\n<tr>\n";
    #print "<th>Data Creazione</th>\n";
    #print "<th>Tipo Annuncio</th>\n";
    #print "<th>Regione Ritiro Carico</th>\n";
    print "<th>Ritiro</th>\n";
    print "<th>Consegna</th>\n";
    print "<th>Data di Carico</th>\n";
    print "<th>Mezzo</th>\n";
    print "<th>Metri di pianale</th>\n";

    if( $print_Contact ne "viewOnly" )
    {
         print "<th>Contatta</th>";
         print "<th>Feedback</th>\n";
    }
    else
    {
        print "<th>Azioni</th>";
	      #print "<th>Azioni</th>\n";
        # print "<th>Stato Feedback</th>";
    }
    print "</tr>\n</thead>\n";

    my @row;
    my $results_found="False";
    # get the total number of results to be able to generate the links
    my $row_cnt = 0;

    my $index_low = $page_num * $mess_per_page;
    my $index_high = ($page_num + 1) * $mess_per_page - 1;

    #print "\$index_low = $index_low\n";
    #print "\$index_high = $index_high\n";

    while (@row = $sth->fetchrow_array) {  # retrieve one row
	# if the message has been served do not show it
        if( $row_cnt >= $index_low and $row_cnt <= $index_high )
        {
	$results_found = "True";
	my $status = $row[13];
	$status = "$status";

	# get the veichle details from the table "vehicle_details"
	my $messageID = $row[0];
        # get the number of unread messages
        my $unread_msg = getNumUnreadMessagesTrip($sid, $messageID);
	# check if the insertionist is on-line:
        #my $ins_online=checkIfUserOnlineFromMid( $messageID );
        my $green_image;
        $green_image = "<img src=\"/images/green.png\" />";
	# if( $ins_online eq "True" )
	# {
  #
	# }
	# else
	# {
  #          $green_image = "<img src=\"/images/red.png\" />";
	# }

	my @vehicle_details = getVehicleDetails( $messageID );

	if( $status eq "0" or ($print_Contact eq "viewOnly" and $status ne "-1") or $print_Contact eq "Requests" )
	{
		print  "<tr>\n";
		my $date_creation = $row[3];
		# split data from timestamp
		my @fields = split(/\ /, $date_creation);
		my $date2 = $fields[0];
		my $timestamp = @fields[1];
		$date2 = american2EuropeanData( $date2 );
		$date_creation = "$date2 $timestamp";
		#print "<td data-th=\"Data Annuncio\">$date_creation</td>";
		my $element = $row[2];

		my $regione = $row[7];
		#print "<td data-th=\"Regione Ritiro Carico\">$element</td>";
		$element = $row[8];
		print "<td data-th=\"Provincia Ritiro Carico\"> $green_image\n $element, $regione</td>";
		$regione = $row[9];
		#print "<td data-th=\"Regione Consegna Carico\">$element</td>";
		$element = $row[10];
		print "<td data-th=\"Provincia Consegna Carico\">$element, $regione</td>";
		$element = $row[4];
		$element = american2EuropeanData( $element );
		    my $element2 = $row[5];
		$element2 = american2EuropeanData( $element2 );

    my $timestamp = generatePGTimestamp();
    # get today's numberla date
    my @tmp = split(" ", $timestamp);
    my $today = $tmp[0];
    my $d = date($today);
    my $dol = date( $row[4] );

		    if( $element eq $element2 )
		    {
		       print "<td data-th=\"Data di Carico\">$element</td>";
		    }
		    else
		    {
		       print "<td data-th=\"Data di Carico\">$element\n<p>(Alternativa: $element2)</p></td>";
		    }
		#print "<td data-th=\"Data di Carico Alternativa\">$element</td>";
		$element = $row[11];
		my $vname = getVeihcleType( $element );
		# print vehicle details
		my $length = $vehicle_details[2];
		my $weight = $vehicle_details[3];
		my $coils = isNull2Integer(  $vehicle_details[4] );
		my $adr = isNull2Integer(  $vehicle_details[5] );
		my $big_volume = isNull2Integer(  $vehicle_details[6] );
		my $adr_image;

		my $vd_str = "Peso: $weight [t]\n";
		# print ADR symbol is necessary
		if( $adr )
		{
		    $adr_image = "<img src=\"/images/adr.png\" />";
		}
		else
		{
		    $adr_image = "";
		}
		if( $coils )
		{
		    $coils_image = "<img src=\"/images/buca_coils_ico.png\" />";
		}
		else
		{
		    $coils_image = "";
		}

		if( $big_volume )
		{
		    $big_volume_image = "<img src=\"/images/grande_volume_ico.png\" />";
		}
		else
		{
		    $big_volume_image = "";
		}

		print "<td data-th=\"Mezzo\">$vname\n$vd_str\n$adr_image\n$coils_image\n$big_volume_image</td>\n";
		print "<td data-th=\"Metri di pianale\">$length</td>\n";

		# print the contact button only if nobady has sent the request
		my $request_sent=$row[14];
		$request_sent = "$request_sent";

		if( $print_Contact ne "viewOnly" )
		{
		   print "<td data-th=\"Contatta\">\n";
		   generateContactButton($row[0], $sid, $page_num);
                   if( $unread_msg )
                   {
                     print "($unread_msg)";
                   }
		   print "</td>\n";
	           # draw the feedback column
       my @comp_data = getCompanyDataFromUserID( $row[1] );
		   #my $feedback= getFeedbackFromUserID( $row[1] );
       my $feedback = $comp_data[0];
       my $company_name= $comp_data[1];
       my $region = $comp_data[2];
       my $province = $comp_data[3];

		   print "<td class=\"popup\" data-th=\"Feedback\">\n";
		   # print "$feedback";
       print "<a href=\"#/\" data-toggle=\"popover$cnt_pop\" data-trigger=\"focus\" data-placement=\"left\" title=\"Dettagli trasportatore\" data-content=\"<p><strong>Rag. sociale:</strong> $company_name</p><p><strong>Regione:</strong> $region</p> <p><strong>Provincia:</strong> $province</p> \">";
       $cnt_pop = $cnt_pop + 1;
		   for (my $i=0; $i < $feedback; $i++)
		   {
          print "<img src=\"/images/star_ico.png\" >";
       }
                   print "</a></td>\n";
		}
		else
		{
		  print "<td data-th=\"Azioni\">\n";
      print "<div hidden>\n";
		  my $num_contacts = generateHTMLChatCombo($row[0], $sid, $page_num);
                  if( $unread_msg )
                  {
                     print "($unread_msg)";
                  }
      print "</div>\n";

                  if ( "$num_contacts" eq "0" )
                  {
                     print "<a href=\"/cgi-bin/editMessage.pl?mid=$messageID&sid=$sid\">Modifica</a>\n";
                     print "<a href=\"/cgi-bin/createMessage.pl?mid=$messageID&sid=$sid\">Duplica</a>\n";
                     # print "<p><a href=\"/cgi-bin/eraseContact.pl?messageID=$messageID&sid=$sid\">Rimuovi</a></p>\n";
                     print <<EOF;
                     <input type="hidden" value="$messageID" id="mid_$count" name="mid_$count">
                     <script src="/dialog_handler_multi.js"></script>
                     <div id="dialog_$messageID" title="Chiusura viaggio">
                       <form id="dia_form_$messageID">
                         <filedset>
                         <input type="radio" name="gender" value="cargo" checked> Ho concluso tramite cargoevolution<br>
                         <input type="radio" name="gender" value="other"> Ho concluso tramite altri circuiti<br>
                         <input type="radio" name="gender" value="err"> Non ho concluso
                         <input type="submit" tabindex="-1" style="position:absolute; top:-1000px">
                         </filedset>
                       </form>
                     </div>
                     <button id="opener_$messageID">Rimuovi</button>
EOF
                     $count = $count  + 1;

                  }
                  else
                  {
                    if( $status eq "0" )
                    {
                      # print "<a href=\"/cgi-bin/eraseContact.pl?messageID=$messageID&sid=$sid\">Rimuovi</a>\n";
                      print "<p>Chat in corso</p>";
                      print <<EOF;
                      <input type="hidden" value="$messageID" id="mid_$count" name="mid_$count">
                      <script src="/dialog_handler_multi.js"></script>
                      <div id="dialog_$messageID" title="Chiusura viaggio">
                        <form id="dia_form_$messageID">
                          <filedset>
                          <input type="radio" name="gender" value="cargo" checked> Ho concluso tramite cargoevolution<br>
                          <input type="radio" name="gender" value="other"> Ho concluso tramite altri circuiti<br>
                          <input type="radio" name="gender" value="err"> Non ho concluso
                          <input type="submit" tabindex="-1" style="position:absolute; top:-1000px">
                          </filedset>
                        </form>
                      </div>
                      <button id="opener_$messageID">Rimuovi</button>
EOF
                      $count = $count  + 1;
                    }

                  }
                  my $messageID = $row[0];
                  my $diff_d = $d - $dol;
                  if( $status eq "3" )
                  {
                    #print "<a href=\"/cgi-bin/eraseContact.pl?messageID=$messageID&sid=$sid\">Rimuovi</a>\n";
                    print "<p>Feedback 100\%</p>";
                    print <<EOF;
                    <input type="hidden" value="$messageID" id="mid_$count" name="mid_$count">
                    <script src="/dialog_handler_multi.js"></script>
                    <div id="dialog_$messageID" title="Chiusura viaggio">
                      <form id="dia_form_$messageID">
                        <filedset>
                        <input type="radio" name="gender" value="cargo" checked> Ho concluso tramite cargoevolution<br>
                        <input type="radio" name="gender" value="other"> Ho concluso tramite altri circuiti<br>
                        <input type="radio" name="gender" value="err"> Non ho concluso
                        <input type="submit" tabindex="-1" style="position:absolute; top:-1000px">
                        </filedset>
                      </form>
                    </div>
                    <button id="opener_$messageID">Rimuovi</button>
EOF
                    $count = $count  + 1;
                  }
                  if( $status eq "2" )
                  {
                    if( $diff_d > 60 )
                    {
                      # print "<a href=\"/cgi-bin/eraseContact.pl?messageID=$messageID&sid=$sid\">Rimuovi</a>\n";
                      print <<EOF;
                      <input type="hidden" value="$messageID" id="mid_$count" name="mid_$count">
                      <script src="/dialog_handler_multi.js"></script>
                      <div id="dialog_$messageID" title="Chiusura viaggio">
                        <form id="dia_form_$messageID">
                          <filedset>
                          <input type="radio" name="gender" value="cargo" checked> Ho concluso tramite cargoevolution<br>
                          <input type="radio" name="gender" value="other"> Ho concluso tramite altri circuiti<br>
                          <input type="radio" name="gender" value="err"> Non ho concluso
                          <input type="submit" tabindex="-1" style="position:absolute; top:-1000px">
                          </filedset>
                        </form>
                      </div>
                      <button id="opener_$messageID">Rimuovi</button>
EOF
                      $count = $count  + 1;
                    }
                    print "<p>Feedback 50\%</p>";
                  }
                  if( $status eq "1" )
                  {
                    if( $diff_d > 60 )
                    {
                      # print "<a href=\"/cgi-bin/eraseContact.pl?messageID=$messageID&sid=$sid\">Rimuovi</a>\n";
                      print <<EOF;
                      <input type="hidden" value="$messageID" id="mid_$count" name="mid_$count">
                      <script src="/dialog_handler_multi.js"></script>
                      <div id="dialog_$messageID" title="Chiusura viaggio">
                        <form id="dia_form_$messageID">
                          <filedset>
                          <input type="radio" name="gender" value="cargo" checked> Ho concluso tramite cargoevolution<br>
                          <input type="radio" name="gender" value="other"> Ho concluso tramite altri circuiti<br>
                          <input type="radio" name="gender" value="err"> Non ho concluso
                          <input type="submit" tabindex="-1" style="position:absolute; top:-1000px">
                          </filedset>
                        </form>
                      </div>
                      <button id="opener_$messageID">Rimuovi</button>
EOF
                      $count = $count  + 1;
                    }
                    print "<p>In attesa di feedback</p>";
                  }
                  #print "\$status = $status";

		              print "</td>\n";
		  # print "<td data-th=\"Azioni\">\n";
		  # my $messageID = $row[0];
		  # print "<a href=\"/cgi-bin/eraseContact.pl?messageID=$messageID&sid=$sid\">Rimuovi</a>\n";
		  # print "</td>\n";
		}
		print "</tr>\n";

       }
       } # print condition
       $row_cnt =  $row_cnt + 1;
    } # while

print "</table>\n";
if( $results_found eq "False" )
{
   print "<div>\n";
   print "<h1>\nNessun Risultato, controlla i filtri</h1>\n";
   print "</div>\n";
}
# generate page links
use integer;
my $cpg=0;
my $page_string = 1;
my $quotient = $N_tot / $mess_per_page;
my $remainder = $N_tot % $mess_per_page;

# select the proper script
my $script_link="goBackSearch.pl";

if( $print_Contact eq "viewOnly" )
{
   $script_link="selectUserMessages.pl";
}
elsif( $print_Contact eq "Requests" )
{
   $script_link="selectUserContactRequests.pl";
}

if( $quotient != 0 )
{
  print "<p>Pagine:&nbsp&nbsp&nbsp \n";
  while( $cpg < $quotient )
  {
     my $highlight;
     if( "$page_num" eq "$cpg" )
     {
       $highlight = "color =\"red\"";
     }
     else
     {
       $highlight = "color =\"black\"";
     }
     print "<a href=\"$script_link?sid=$sid&page_num=$cpg\"><font $highlight>$page_string</font></a>&nbsp&nbsp&nbsp&nbsp\n";
     $cpg =  $cpg + 1;
     $page_string = $page_string + 1;
  }
  if( $remainder != 0 )
  {
     my $highlight;
     if( "$page_num" eq "$cpg" )
     {
       $highlight = "color =\"red\"";
     }
     else
     {
       $highlight = "color =\"black\"";
     }
     print "<a href=\"$script_link?sid=$sid&page_num=$cpg\"><font $highlight>$page_string</font></a>&nbsp&nbsp&nbsp&nbsp\n";
  }
  print "</p>\n";
}

print <<EOF;
</div>
</div>
EOF

generateHTMLFooter();
for(my $i=0; $i <$cnt_pop; $i++)
{
  print <<EOF;
  <script>
  \$(window).on('load', function(){
      console.log('popover$i');
      \$('[data-toggle="popover$i"]').popover({html: true});
  });
  </script>
EOF
}

print <<EOF;
</body>
</html>

EOF

}
1;
