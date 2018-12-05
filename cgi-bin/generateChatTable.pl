use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use Path::Class;

use DBI;
use DBD::Pg;
use DBD::Pg qw(:pg_types);

require "../cgi-bin/convertPGtimestamp2EurDateTime.pl";
require "../cgi-bin/getFeedbackFromUserID.pl";
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/getDatabasePwd.pl";

sub generateChatTable
{
   my $sth=$_[0];
   my $MyID=$_[1];
   my $uid_other=$_[2];
   my $sid=$_[3];
   my $mid=$_[4];

   # retrieve user's feedback
   my $did_feedback= getFeedbackFromUserID( $uid_other );
   # get my feed_back
   my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
   my $my_feedback = $session->param("my_feedback_stat");

   print "<table class=\"chat\"\n>";

   while (my @row = $sth->fetchrow_array) {

     my $uid_from_db = $row[0];
     my $text = $row[1];
     my $creation_time = $row[2];
     my $did = $row[3];
     my $m_read= $row[4];
     $creation_time = convertPGtimestamp2EurDateTime( $creation_time );

     if( $MyID eq $uid_from_db )
     {
	if( $uid_other eq $did )
        {
           print "<tr>\n";
           print "<td class=\"clip-message2\"><p>$text</p><p style=\"font-size:10px\">$creation_time</p>\n<p>\n";
          #  for (my $i=0; $i < $my_feedback; $i++)
          #  {
          #     print "<img src=\"/images/star_ico.png\" >";
          #  }
           if( "$m_read" eq "1")
           {
             print "<p>\n<img src=\"/images/read2.png\" >\n</p>\n";
           }
           print "</p><p style=\"color : gray\">@@@@@@@@@@@@@<p>\n";
           print "</td>\n";
           print "<td class=\"separator\"><hr/></td>\n";
           print "<td class=\"hidden\"></td>\n";
           print "</tr>\n";
        }
     }
     else
     {
	if( $did eq $MyID and $uid_other eq $uid_from_db )
	{
           print "<tr>\n";
           print "<td class=\"hidden\"></td>\n";
           print "<td class=\"separator\"><hr/></td>\n";
           print "<td class=\"clip-message\"><p>$text</p><p style=\"font-size:10px\">$creation_time</p>\n<p>\n";
           for (my $i=0; $i < $did_feedback; $i++)
           {
              print "<img src=\"/images/star_ico.png\" >";
           }
           print "</p><p style=\"color : gray\">@@@@@@@@@@@@@<p>\n";
           print "</td>\n";
	   print "</tr>\n";
	}
     }
   }

   print "</table>";
   # mark messages as read
   # retrieve data fromdatabase
   my $PG_COMMAND="update chats set read=1  where mid=? and did=? and uid=?";

   # connect to database
   my $database_name=getDatabaseName();
   my $db_username=getDatabaseUsername();
   my $db_pwd=getDatabasePwd();

   # connect to the database
   my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
      or die $DBI::errstr;

   my $sth2 = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

   $sth2->execute( $mid, $MyID,  $uid_other )
      or die "Can't execute SQL statement: $dbh::errstr\n";
}
1;
