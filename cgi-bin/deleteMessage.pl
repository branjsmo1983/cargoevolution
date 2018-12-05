use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

sub deleteMessage
{
    my $messageID = $_[0];
    my $type = $_[1];

    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();

    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;

   my $PG_COMMAND;
   if( $type eq "-1" )
   {
     $PG_COMMAND="UPDATE messages2 SET status = '-1' WHERE id = ?";
   }
   else
   {
     $PG_COMMAND="UPDATE messages2 SET status = '$type' WHERE id = ?";
   }

    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute( $messageID )
        or die "Can't execute SQL statement: $dbh::errstr\n";
    $sth->finish;
    $dbh->disconnect();
}
1;
