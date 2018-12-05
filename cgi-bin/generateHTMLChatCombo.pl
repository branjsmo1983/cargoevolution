use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);

require "../cgi-bin/getChatInsertion.pl";
require "../cgi-bin/getUidsForChat.pl";

sub generateHTMLChatCombo{
  my $messageID= $_[0];
  my $sid=$_[1];
  my $page_num=$_[2];
  my $oid = $_[3];

   my $button_string;

   if($oid )
   {
      $button_string = "Rispondi";
   }
   else
   {
      $button_string = "Chat";
   }

  my @unique_uids = getUidsForChat( $messageID, $sid );

  if ( (scalar @unique_uids) != 0 )
  {
     my $cgi_script="contactUserCombo.pl#bottom_page";
     print "<form name=\"ContactFormCombo$messageID\" action=\"/cgi-bin/$cgi_script\" method=\"post\" enctype=\"multipart/form-data\">\n";
     if( $oid )
     {
        # find index
	my $search = $oid;
	my %index;
	@index{@unique_uids} = (0..$#unique_uids);
	my $uindex = $index{$search};
	# print "$uindex";
        if( $uindex >= 0 )
        {
          print  "<input type=\"hidden\" id=\"chatCombo\" name=\"chatCombo\" value=\"$uindex\">";
        }
        else
        {
          die "User not found $oid, @unique_uids ";
        }

	print  "<input type=\"hidden\" id=\"fromQuickLinks\" name=\"fromQuickLinks\" value=\"1\">";
     }
     else
     {

	  print  "<select id=\"chatCombo\" ";
	  print  "name=\"chatCombo\" >";
	  my $cnt;
	  $cnt = 0;
	  my $cnt_disp;

	  foreach $p (@unique_uids)
	  {
	    $cnt_disp = $cnt + 1;
	    if(  $cnt == $selected )
	    {
	        print "<option value=\"$cnt\" selected>Vettore$cnt_disp</option>\n";
	    }
	    else
	    {
		print "<option value=\"$cnt\">Vettore$cnt_disp</option>\n";
	    }
	    $cnt = $cnt +1;
	  }
	  print "</select>\n";
     }

   print "<input id=\"ContactMessageID\" name=\"ContactMessageID\" value=$messageID type=\"hidden\" />"; # the name of the variable is misleading, it is the ID of the message in the table not the ID of the user itself
   print "<input id=\"sid\" name=\"sid\" value=$sid type=\"hidden\" />";
   print "<input id=\"page_num\" name=\"page_num\" value=$page_num type=\"hidden\" />";

   print "<input id=\"ContactButton$messageID\" type=\"submit\" name=\"ContactButton$messageID\" value=\"$button_string\" />";
   print "</form>\n";
  }

  my $num_contacts = scalar @unique_uids;
  return $num_contacts;
}
1;
