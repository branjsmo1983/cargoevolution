use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/escapeTextForPostgres.pl";

sub generateHTMLChat
{
   my $mid=$_[0];
   my $quick_links=$_[1];
   
   # retrieve messages from database
   my $database_name=getDatabaseName();
   my $db_username=getDatabaseUsername();
   my $db_pwd=getDatabasePwd();
    
   # connect to the database
   my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;
  
   my $PG_COMMAND="select * from message_chats where mid=? order by creation_time";
   my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

   $sth->execute( $mid )
       or die "Can't execute SQL statement: $dbh::errstr\n";
   
   print "<table>\n";
   print "<thead>\n<tr>\n";
   print "<th>You</th>\n";
   print "<th>Yout Timestamp</th>\n";
   print "<th>My Timestamp</th>\n";
   print "<th>Me</th>\n";
   print "</tr>\n</thead>\n";
   
   my @row;
     
   while (@row = $sth->fetchrow_array) {
   
   }
   print "\n</table>\n";
}
1;
