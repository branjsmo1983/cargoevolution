use cPanelUserConfig;


sub generateWriteButton
{
   my $messageID= $_[0];
   my $sid=$_[1];
   my $user_type=$_[2];
   
   my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
   
   if( $user_type )
   {
      $session->param("buyer", "True");
   }
   else
   {
      $session->param("buyer", "False");
   }
   
   
   my $cgi_script="writeUser.pl";
   print "<form name=\"WriteForm$messageID\" action=\"/cgi-bin/$cgi_script\" method=\"post\" enctype=\"multipart/form-data\">\n";
   print "<input id=\"WriteMessageID\" name=\"WriteMessageID\" value=$messageID type=\"hidden\" />"; # the name of the variable is misleading, it is the ID of the message in the table not the ID of the user itself
   print "<input id=\"sid\" name=\"sid\" value=$sid type=\"hidden\" />";
   print "<input id=\"WriteButton$messageID\" type=\"submit\" name=\"WriteButton$messageID\" value=\"Scrivi all'utente\" />";
   print "</form>\n";
}
1;
