use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;

require "../cgi-bin/getChatInsertion.pl";
require "../cgi-bin/generateHTMLFooter.pl";
require "../cgi-bin/generateHTMLheader.pl";
require "../cgi-bin/printTripInformation.pl";
require "../cgi-bin/getUidFromMessageID.pl";
require "../cgi-bin/getMessageStatus.pl";
require "../cgi-bin/convertPGtimestamp2EurDateTime.pl";
require "../cgi-bin/generateChatTable.pl";
require "../cgi-bin/getTripInformationFromMID.pl";
require "../cgi-bin/getEmailFromUserID.pl";
require "../cgi-bin/getNameFromUserID.pl";
require "../cgi-bin/getBuyerID.pl";
require "../cgi-bin/getPhoneNumbers.pl";
require "../cgi-bin/cleanPhoneNumbers.pl";
require "../cgi-bin/getDemoAccountId.pl";
require "../cgi-bin/getTripInformation.pl";

sub generateChatForm{

   my $cgi_script="insertChatText.pl";
   my $sid=$_[0];
   my $mid=$_[1];
   my $MyID=$_[2];
   my $message=$_[3];
   my $uid_other=$_[4];
   my $multi=$_[5];

   my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
   # retrieve the last action type
   my $last_action = $session->param("last_action");
   my $page_num = $session->param("page_num");
   my $trip_info_with_no_link = getTripInformationFromMID( $mid );
   my $trip_info_with_no_contact = getTripInformation($mid);
   my $from_quick_links = $session->param("fromQuickLinks");

   #print "\$uid_other=$uid_other\n";
   #print "\$multi=$multi\n";

   if( $message )
   {

   }
   else
   {
      print header (-charset => 'UTF-8');
   }
   print "<html>\n";
   my $javascript_insert_script = "<script type=\"text/javascript\" src=\"/chat_insert.js\"></script>\n";
   my $javascript_refresh;

   if( $multi or "$multi" eq "0" )
   {
	   $javascript_refresh='<script type="text/javascript">
	   $(document).ready(function() {$(\'.commentarea\').keydown(function(event) {
		   if (event.keyCode == 13) {
		       $(ContactChatForm).submit();
                        setTimeout(function(){  perlExecuteChatUpdateTableMulti();   }, 600);
		       return false;
		    }
	       });
	   }); </script>';
   }
   else
   {
	   $javascript_refresh='<script type="text/javascript">
	   $(document).ready(function() {$(\'.commentarea\').keydown(function(event) {
		   if (event.keyCode == 13) {
		       $(ContactChatForm).submit();
                       setTimeout(function(){  perlExecuteChatUpdateTableSingle();   }, 600);
		       return false;
		    }
	       });
	   }); </script>';
   }

#   my $javascript_refresh = "<link rel=\"stylesheet\" type=\"text/css\" href=\"/css/cargoevolution.css\" media=\"screen and (min-device-width: 800px)\" />
#<link rel=\"stylesheet\" media=\"screen and (max-device-width: 801px)\" href=\"/css/cargoevolution_smartphone.css\" />
#<link rel=\"stylesheet\" type=\"text/css\" href=\"cargoevolution2.css\" />";

   $javascript_insert_script =  "$javascript_insert_script $javascript_refresh";

   generateHTMLheader("Contatta Trasportatore", $javascript_insert_script);
   #print "<body translate=\"no\">\n<header><h1>Chat</h1><center><div style=\"width:50\%;color:white;\">$trip_info_with_no_link<div></center></header>\n";
   print "<center>\n";
   if( $multi or "$multi" eq "0" )
   {
     print "<p>\n<a href=\"javascript:history.back()\">Clicca qui per tornare Indietro</a>\n</p>\n";

   }
   else
   {
      my $sth;
      if( $last_action eq "my_search" )
      {
         $sth = $session->param("sth_session");
         if( $from_quick_links )
         {
            print "<p>\n<a href=\"javascript:history.back()\">Clicca qui per tornare Indietro</a>\n</p>\n";
         }
         else
         {
            print "<p>\n<a href=\"goBackSearch.pl?sid=$sid&page_num=$page_num\">Clicca qui per tornare Indietro</a>\n</p>\n";
         }

      }
      else
      {
         print "<p>\n<a href=\"javascript:history.back()\">Clicca qui per tornare Indietro</a>\n</p>\n";
      }
   }

   # get message status before printing commands
   my $status = getMessageStatus( $mid );
   my $bid = getBuyerID( $mid );
   my $uid_in_msg =getUidFromMessageID( $mid );
   my $email_did = getEmailFromUserID( $uid_other );
   my $name = getNameFromUserID( $uid_other );
   my $phone_nums = getPhoneNumbers( $uid_other );

   my $mobile;
   my $phone;

   my @tmp_phone = split '!', $phone_nums;
   my $two_numbers;

   if( (scalar @tmp_phone ) > 1 )
   {
     $phone = $tmp_phone[0];
     $phone = cleanPhoneNumbers($phone);
     $mobile = $tmp_phone[1];
     $mobile = cleanPhoneNumbers($mobile);
     $two_numbers = "True";
   }
   else
   {
      $two_numbers = "False";
      $phone = $tmp_phone[0];
      $phone = cleanPhoneNumbers($phone);
   }

   # retrieve messages from this chat
   my $sth = getChatInsertion( $mid );

   print "<div id=\"ChatTable\" name=\"ChatTable\">";
   generateChatTable($sth, $MyID, $uid_other, $sid, $mid);
   print "<a  name=\"bottom_page\"></a>\n";
   print "</div>";

if( "$status" eq "0" )
{
   print "<p><form id=\"ContactChatForm\" name=\"ContactChatForm\" method=\"post\" action=\"\" >\n";
   print "<input type=\"hidden\" id=\"sid\" name=\"sid\" value=\"$sid\" />\n";
   # ContactMessageID
   print "<input type=\"hidden\" id=\"ContactMessageID\" name=\"ContactMessageID\" value=\"$mid\" />\n";
   if( $multi or "$multi" eq "0" )
   {
      print "<input type=\"hidden\" id=\"multi\" name=\"multi\" value=\"multi\" />\n";
      print "<input type=\"hidden\" id=\"chat_index\" name=\"chat_index\" value=$multi />\n";
   }

   my $demo_id = getDemoAccountId();

   if( $demo_id eq $MyID )
   {
     print "<textarea class=\"commentarea\" name=\"ctext\" id=\"ctext\" maxlength=\"120\" cols=\"40\" rows=\"1\" placeholder=\"Scrivi qui... DEMO\" disabled></textarea>\n";
   }
   else
   {
     print "<textarea class=\"commentarea\" name=\"ctext\" id=\"ctext\" maxlength=\"120\" cols=\"40\" rows=\"1\" placeholder=\"Scrivi qui...\"></textarea>\n";
     print "<button type=\"submit\" class=\"button positive\" id=\"WriteMsg\" name=\"WriteMsg\">Invia</button>";
   }

   print "</form><\p>\n";
   if( $Two_numbers == "True" )
   {
     print "<h2> <a href=\"mailto:$email_did\">   <img src=\"/img/email.png\"  height=\"64\" width=\"64\" / > </a> Azienda: $name <a href=\"tel:$mobile\"> <img src=\"/img/tel.png\"  height=\"64\" width=\"64\" / > Cell. $mobile </a> </h2>\n";
   }
   else
   {
     print "<h2> <img src=\"/img/email.png\"  height=\"64\" width=\"64\" / > Azienda: $name <a href=\"tel:$phone\"> <img src=\"/img/tel.png\"  height=\"64\" width=\"64\" / > Tel. $phone </a> </h2>\n";
   }

   # add the button to close the chat and have a winner
   if( $multi or "$multi" eq "0" )
   {
     print "<p>\n";
     print "<form action=\"/cgi-bin/closeChat.pl\" method=\"post\" accept-charset=\"utf-8\" enctype=\"multipart/form-data\" >\n";
     print "<input type=\"hidden\" id=\"sid\" name=\"sid\" value=\"$sid\" />\n";
     print "<input type=\"hidden\" id=\"chat_index\" name=\"chat_index\" value=$multi />\n";
     print "<input type=\"hidden\" id=\"ContactMessageID2\" name=\"ContactMessageID2\" value=\"$mid\" />\n";
     print "<input type=\"submit\" class=\"button positive\" id=\"CloseChat\" name=\"CloseChat\" value=\"Conferma Trasportatore\" />\n";
     print "</form>\n";
     print "</p>\n";
   }
}


print "<body translate=\"no\">\n<header><h1>Chat</h1><center><div><ul style=\"width:50\%;color:white;display:inline;list-style: none\">$trip_info_with_no_contact</ul><div></center></header>\n";
print "<center>\n";


if( "$status" ne "0" and "$bid" eq "$MyID"  )
{

   print "<hr><p><img src=\"/images/green.png\">Trasporto concordato con: <a href=\"mailto:$email_did\">$email_did</p><hr>";
}
elsif( "$status" ne "0" and "$bid" ne "$MyID" )
{
  if( "$uid_in_msg" ne "$MyID" )
  {
       print "<hr><p><img src=\"/images/red.png\">Trasporto non più disponibile </p><hr>";
  }
  else
  {
       if( "$bid" eq "$uid_other" )
       {
          print "<hr><p><img src=\"/images/green.png\" >Trasporto concordato con: <a href=\"mailto:$email_did\">$email_did</p><hr>";
       }

  }

}

print "
<script type=\"text/javascript\">
function stampa(){
if (window.print) {
window.print() ;
} else {
var WebBrowser = '<OBJECT ID=\"WebBrowser1\" width=0 height=0 CLASSID=\"CLSID:8856F961-340A-11D0-A96B-00C04FD705A2\"></OBJECT>'; document.body.insertAdjacentHTML('beforeEnd', WebBrowser); WebBrowser1.ExecWB(6, 2);
}
}
</script>
<form>
<hr/>
<input type=\"image\" src=\"/images/pdf.jpg\" height=\"45\" width=\"45\" value=\"Stampa questa pagina\" name=\"Print\" onClick=\"stampa()\">
</form>


";

if( $multi or "$multi" eq "0" )
{
  print "<p>\n<a href=\"javascript:history.back()\">Clicca qui per tornare Indietro</a>\n</p>\n";

}
else
{
   my $sth;
   if( $last_action eq "my_search" )
   {
      $sth = $session->param("sth_session");
      if( $from_quick_links )
      {
         print "<p>\n<a href=\"javascript:history.back()\">Clicca qui per tornare Indietro</a>\n</p>\n";
      }
      else
      {
         print "<p>\n<a href=\"goBackSearch.pl?sid=$sid&page_num=$page_num\">Clicca qui per tornare Indietro</a>\n</p>\n";
      }

   }
   else
   {
      print "<p>\n<a href=\"javascript:history.back()\">Clicca qui per tornare Indietro</a>\n</p>\n";
   }
}


   print "</center>\n";

   generateHTMLFooter();
   print "</body>\n<html>\n";
}
1;
