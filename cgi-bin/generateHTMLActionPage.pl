use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use Path::Class;

require "../cgi-bin/italia.pl";
require "../cgi-bin/generateHTMLSelectorRegionIT.pl";
require "../cgi-bin/generateHTMLSelectorProvinceIT.pl";
require "../cgi-bin/getUsernameFromUserID.pl";
require "../cgi-bin/generateHTMLheader.pl";
require "../cgi-bin/generateHTMLopenTag.pl";
require "../cgi-bin/generateHTMLFooter.pl";
require "../cgi-bin/getVeihcleType.pl";
require "../cgi-bin/validateUserID.pl";
require "../cgi-bin/generateErrorPage.pl";
require "../cgi-bin/generateHTMLUserActionLinks.pl";
require "../cgi-bin/getNumUsersOnlineFile.pl";
require "../cgi-bin/generateHTMLQuickButtons.pl";
require "../cgi-bin/updateTimeLastAction.pl";
require "../cgi-bin/getUserNumber.pl";
require "../cgi-bin/getCompanyNameFromUserId.pl";
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/convertPGtimestamp2EurDateTime.pl";
require "../cgi-bin/getDemoAccountId.pl";
require "../cgi-bin/getConditionsFromUserID.pl";
require "../cgi-bin/generateHTMLRegionsIT.pl";
require "../cgi-bin/getNumRegionsInterest.pl";
require "../cgi-bin/getPhoneNumFromCompanyName.pl";

sub generateHTMLActionPage
{
my $form_type=$_[0];
my $SID_from_calling_function = $_[1];
my $sessionID;
my $from_login_arg=$_[2];
my $cgi_script;
my $button_string;
my $title;
my $userNumber = getUserNumber() - 8;


my $q = CGI->new();
my $userID_from_CGI;
my $from_login;

if( $SID_from_calling_function and $form_type ne "insert" )
{
   $sessionID = $SID_from_calling_function;
}
else
{
   # get the ID from CGI
   $sessionID = $q->param('sid');
   $from_login = "False";
}

#get the username from the user session
my $session;

# print "\$sessionID = $sessionID\n";
$session = new CGI::Session(undef, $sessionID, {Directory=>"/tmp"});
$userID_from_CGI = $session->param("username");
updateTimeLastAction( $userID_from_CGI );
$companyName = getCompanyNameFromUserId($userID_from_CGI);

$name = $session->param("name");
my $feedback = $session->param("feedback");
my $privacy = $session->param("privacy");
my $conditions = $session->param("conditions");

if( $from_login_arg and $form_type ne "insert" )
{
   $from_login = "True";
}
else
{
   $from_login = "False";
}

my $is_user_valid =validateUserID( $userID_from_CGI, $sessionID );

#if( $is_user_valid  eq "False")
#{
 #  generateErrorPage("Invalid User");
  # exit;
#}
my $num_int_regions = getNumRegionsInterest( $userID_from_CGI  );

# write ID to onesignal to identify user
# print "<script>OneSignal.sendTag(\"id\", $userID_from_CGI);</script>";

my $require_date_of_loading;
if( $form_type eq "insert" )
{
    # we should never get here
    exit;
}
else
{
   $cgi_script = "select.pl";
   $button_string = "Avanti";
   my $cn_limites = substr($companyName,0, 21);
   $title = "$cn_limites";
   $require_date_of_loading = "";
}

# detect if the form is a re-issue for the correction of missing, inconsistent data
my $message_type=$_[1];
my $MT=$_[2];
my $date_of_loading1=$_[3];
my $DL1=$_[4];
my $date_of_loading2=$_[5];
my $DL2=$_[6];
my $pick_up_region=$_[7];
my $PUR=$_[8];
my $pick_up_province=$_[9];
my $PUP=$_[10];
my $delivery_region=$_[11];
my $DR=$_[12];
my $delivery_province=$_[13];
my $PUR=$_[14];
my $veihcle_type=$_[15];
my $VT=$_[16];

my $message_to_the_user;

if( ($message_type or $MT eq "Fahiddelse") and ( $form_type eq "insert" ) )
{
   $title = "Completa i campi <mark>evidenziati</mark>";
   $message_to_the_user = "Messaggio non salvato.";

}
else
{
   $message_to_the_user = "";
}

if(  $from_login eq "False" )
{
	print <<EOF;
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 5.0 Final//IT" >
EOF

	my $addtional_tags = "<script src=\"/js-webshim/minified/polyfiller.js\"></script>\n<script>\nwebshim.polyfill('forms forms-ext');\nwebshim.setOptions('forms-ext', {types: 'date'});\nwebshims.setOptions('waitReady', false);\n</script>\n<script type=\"text/javascript\" src=\"/pick_up_region.js\">\n</script>\n";
	$addtional_tags = "$addtional_tags<script type=\"text/javascript\" src=\"/delivery_region.js\">\n</script>\n";
	$addtional_tags = "$addtional_tags<script type=\"text/javascript\" src=\"/map_handling.js\">\n</script>\n";
  # <script src="http://www.openlayers.org/api/OpenLayers.js"></script>

	generateHTMLopenTag();
	generateHTMLheader("Cargoevolution", $addtional_tags);
	print "<body>\n";
}
print <<EOF;
<input type=\"hidden\" id=\"sid\" name=\"sid\" value =\"$sessionID\">
EOF
print '<style> .imgContainer { float:left; } figcaption { font-size: 22px; } .msgContainer { float:bottom; font-size: 32px; color: black;} hr { border-color : gray; }
</style>';
print '<style>
.imgContainer:hover {
    border: 8px solid #00cc00;
}
</style>';

# get privac<script src="https://code.jquery
my @conditions=getConditionsFromUserID( $userID_from_CGI );
$privacy = $conditions[0];
$conditions= $conditions[1];

if( "$privacy" eq "0")
{

print <<EOF;

<div id="userAlert" name="userAlert">
  <div class="container" style="background-color: black;">
    <div class="col-md-1 col-sd-1 col-xs-1">
    <input id="privacyButton" type="button" value="OK" onclick="setPrivacy(1);" />
    </div>
    <div class="col-md-8 col-sd-8 col-xs-8">
    <a href="/privacy.pdf" target="_blank">Leggi l'informativa sulla privacy ed accetta le condizioni premendo OK</a>
    </div>
  </div>
</div>

EOF
$session->param("privacy", "1");
}

if( "$conditions" eq "0" )
{
print <<EOF;

<div id="userAlertConditions" name="userAlertConditions">
<div class="container" style="background-color: black;">
  <div class="col-md-1 col-sd-1 col-xs-1">
  <input id="conditionsButton" type="button" value="OK" onclick="setConditions(1);" />
  </div>
  <div class="col-md-8 col-sd-8 col-xs-8">
  <a href="/condizioni.pdf" target="_blank">Leggi i termini e le condizioni del servizio, ed accetta premendo OK</a>
  </div>
  </div>
</div>
EOF
$session->param("conditions", "1");
}


print "<header style=\"background-size:100%\">\n
<h1>
<div class=\"container\">
  <div class=\"row\">
    <div class=\"col-lg h3\">
      <font color=\"white\"> $companyName &emsp;</font>";
              for(my $i=0; $i<$feedback; $i++)
              {
                print "<img src=\"/images/star_ico.png\" >";
              }
              print "
    
    <\/div>
  <\/div>
<\/div>


<\/h1>

\n";
# insert link to user account managenet
print "
<h2>
 <div class=\"container\">
  <div class=\"row justify-content-between\">
    <div class=\"col-lg-4\">
      <a href=\"/cgi-bin/updateAccount.pl?sid=$sessionID\" class=\"btn btn-default btn-lg\"> Gestisci il tuo account</a>&emsp;
    <\/div>
        <div class=\"col-lg-4\"> 
      <a href = \"http://www.cciss.it/ \" target=\"_blank\" class=\" btn btn-danger btn-lg\" style=\"font-size:23px;\" >Info Traffico in tempo reale</a> 
   <\/div>
    <div class=\"col-lg-4\">
      <a href=\"logout.pl?sid=$sessionID\" class=\"btn btn-default btn-lg\">Log out</a>&emsp;
   <\/div>

  <\/div>
<\/div> 
 <\/h2>
<!-- <p>&nbsp;</p> -->

";
print "<div ><h3><font color=\"white\"><i>NEWS: $userNumber Trasportatori iscritti</i></font></h3></div>
      <!--  <div><a href = \"http://www.cciss.it/ \" target=\"_blank\" class=\" btn btn-danger btn-lg\" style=\"font-size:23px; \">Info Traffico in tempo reale</a></div> -->
       ";
print "<p>$message_to_the_user</p>\n</header>\n";

generateHTMLUserActionLinks( $sessionID );


print "<div class=\"container\">";
if( $num_int_regions == 0 )
{
  print "<div class=\"row\"> <div class=\"col-md-10 col-sm-10 col-xs-10\">\n";
  print "<div id=\"mapRegions\" name=\"mapRegions\">";
  print "<p> Aiutaci a migliorare il servizio. Clicca sulle regioni per selezionare l'area dei viaggi a cui sei interessato. Potrai sempre modificare la tua selezione accedendo alla sezione <a href=\"updateAccount.pl?sid=$sessionID\"> Gestisci account</a> </p> <button class=\"submit btn btn-primary\" onclick=\"resetRegionDiv()\">Chiudi Mappa</button> ";
  generateHTMLRegionsIT();
  print "</div></div></div>\n";
}
print "<div class=\"row\">";
print "<div class=\"col-md-5 col-sm-5 col-xs-5\">";
generateHTMLQuickButtons("/cgi-bin/login_succ.pl?sid=$sessionID", "/cgi-bin/login_succ_view.pl?sid=$sessionID", $sessionID, "/cgi-bin/selectUserChats.pl?sid=$sessionID","/cgi-bin/insertTruck.pl?sid=$sessionID");
# insert logo image here "logo.png"
#print <<EOF;
#<embed src="/index_inner.html" style="width:90%; height: 90%;">
#EOF
# <p><a href="https://youtu.be/fH9pSYJdS2o"> Video di guida alla registrazione </a></p>
# <p><a href="https://youtu.be/o59E4dO4hiU"> Video di guida all'accesso </a></p>
print <<EOF;
<div>
<hr />

</div>
EOF
print "</div> ";
print "<div class=\"col-md-5 col-sm-5 col-xs-5\">";

print "<div class=\"panel panel-primary\">
                <div class=\"panel-heading\" id=\"accordion\">
                    <span class=\"glyphicon glyphicon-comment\"></span> Bacheca
                </div>";

my $demo_id = getDemoAccountId();
if( $demo_id eq $userID_from_CGI  )
{
  print " <form class=\"panel-footer\" id=\"sendForm\" name=\"sendForm\" action=\"\" method=\"\" >
               <div class=\"input-group\">
                    <input type=\"text\" class=\"form-control input-sm\" id=\"message\" name=\"message\"  placeholder=\"Scrivi qui un tuo messaggio...\" disabled />
                  <input type=\"hidden\" id=\"company\" name=\"company\" value =\"$companyName\">
                        <span class=\"input-group-btn\">
                                <button class=\"btn btn-warning btn-sm\" id=\"btn-chat\">
                                    Inserisci</button>
                        </span>
               </div>         
  	      </form>	";
}
else
{
  print " <form class=\"panel-footer \" id=\"sendForm\" name=\"sendForm\" action=\"\" method=\"\" >
                <div class=\"input-group\">
  			        <input type=\"text\" id=\"message\" name=\"message\" class=\"form-control input-sm\" placeholder=\"Scrivi qui un tuo messaggio...\" />
               <input type=\"hidden\" id=\"company\" name=\"company\" value =\"$companyName\" />
                    <span class=\"input-group-btn\">
                            <button class=\"btn btn-warning btn-sm\" id=\"btn-chat\">
                                Inserisci</button>
  		      	      </span>
                    </div>
  	      </form>	";
}

  my $database_name=getDatabaseName();
  my $db_username=getDatabaseUsername();
  my $db_pwd=getDatabasePwd();
                   # connect to the database
  my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;

  my $PG_COMMAND="select DISTINCT message,date,uid from blog order by date DESC,uid LIMIT 20";
  my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

  $sth->execute()
     or die "Can't execute SQL statement: $dbh::errstr\n";




   my @row;
   print "  <div class=\"panel-collapse\" id=\"collapseOne\">
                <div class=\"panel-body\">
            <ul class=\"chat\">";
            

while (@row = $sth->fetchrow_array) {
   my $userCompany = $row[2];
   my $userNumPhones = getPhoneNumFromCompanyName($userCompany);
   my $creation_time = convertPGtimestamp2EurDateTime( $row[1] );
   my $message = $row[0];
   my $findE = "è";
   my $replaceE = "&egrave;";
   my $findA = "à";
   my $replaceA = "&agrave;";
   my $findU = "ù";
   my $replaceU = "&ugrave;";
   my $findO = "ò";
   my $replaceO = "&ograve;";
   my $findI = "ì";
   my $replaceI = "&igrave;";
   my $find_dot = "!";
	 my $replace_dot = " e ";
   $userNumPhones =~ s/$find_dot/$replace_dot/g;
   $message =~ s/$findE/$replaceE/g;
   $message =~ s/$findA/$replaceA/g;
   $message =~ s/$findU/$replaceU/g;
   $message =~ s/$findO/$replaceO/g;	
   $message =~ s/$findI/$replaceI/g;
   print "<li class=\"clearfix\">
                            <div class=\"chat-body clearfix\">
                                <div class=\"header\">
                                    <small class=\"primary-font\">$userCompany</small><br/>
                                    $userNumPhones <br/>
                                     <small class=\" text-muted\">
                                        <span class=\"glyphicon glyphicon-time\"></span>$creation_time</small>
                                </div>
                                <p><i><font color=\"blue\">
                                   $message
                                    </font>
                                   </i>
                                </p>
                            </div>
                        </li>
                        ";
}
   print "</ul>";
print "</div>";
print "</div>";
print "</div>";
print "</div>";
print "</div>";
print "</div>";
my $map_enabled = $q->param('map_enabled');

if( $map_enabled )
{
  print <<EOF;

  <div class="row">
    <div class="col-md-12  col-sm-12  col-xs-12" id="map" name="map"></div>
  </div>

EOF

}

my $num_users_online = getNumUsersOnlineFile();
my $tmpMsg = "Utenti on-line: $num_users_online";

# print <<EOF;
# <script type="text/javascript"> setTimeout(function() { location.reload(); }, 20000); </script>
# EOF

generateHTMLFooter( $tmpMsg );
print <<EOF;

<script type="text/javascript" src="/regionMap.js" ></script>

EOF
if(  $from_login eq "False" )
{
   print "</body>\n";
   print "</html>\n";
}
else
{
   #print "<message> Questo funziona </message>\n";
}


}
1;
