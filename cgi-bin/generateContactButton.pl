sub generateContactButton{

   my $messageID= $_[0];
   my $sid=$_[1];
   my $page_num=$_[2];
   my $from_ql = $_[3];
   my $button_string;

   if( $from_ql )
   {
      $button_string = "Rispondi";
   }
   else
   {
      $button_string = "Chat";
   }

   my $cgi_script="contactUser.pl#bottom_page";
   print "<form name=\"ContactForm$messageID\" action=\"/cgi-bin/$cgi_script\" method=\"post\" enctype=\"multipart/form-data\">\n";
   print "<input id=\"ContactMessageID\" name=\"ContactMessageID\" value=$messageID type=\"hidden\" />"; # the name of the variable is misleading, it is the ID of the message in the table not the ID of the user itself
   print "<input id=\"sid\" name=\"sid\" value=$sid type=\"hidden\" />\n";
   print "<input id=\"fromQuickLinks\" name=\"fromQuickLinks\" value=\"$from_ql\" type=\"hidden\" />\n";
   print "<input id=\"page_num\" name=\"page_num\" value=$page_num type=\"hidden\" />\n";
   print "<input id=\"ContactButton$messageID\" type=\"submit\" name=\"ContactButton$messageID\" value=\"$button_string\" />";
   print "</form>\n";
}
1;
