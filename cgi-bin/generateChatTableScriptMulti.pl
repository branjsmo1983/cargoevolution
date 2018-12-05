use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use CGI::Session;
use DBI;
use strict;
use warnings;
use Fcntl qw(:flock SEEK_END);

require "../cgi-bin/generateChatTable.pl";
require "../cgi-bin/getChatInsertion.pl";
require "../cgi-bin/getUidsForChat.pl";

sub generateChatTableScriptMulti
{
   my $mid = $_[0];
   my $sid = $_[1];
   my $num_user_to_contact = $_[2];

   # get user ID from user session
   my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
   my $MyID = $session->param("username");
   # retrieve messages from this chat
   my @uids = getUidsForChat( $mid, $sid );
   my $uid_other=$uids[$num_user_to_contact]; # this is the $did

   # retrieve messages from this chat
   my $sth = getChatInsertion( $mid );

   generateChatTable($sth, $MyID, $uid_other, $sid, $mid);
}
1;
