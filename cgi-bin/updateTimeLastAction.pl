use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/generatePGTimestamp.pl";

sub updateTimeLastAction
{
    my $userID= $_[0];
    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();
    my $time_stamp = generatePGTimestamp();
    
    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;
  
    my $PG_COMMAND="update users3 set time_last_action=? where id=?";
    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute( $time_stamp, $userID )
        or die "Can't execute SQL statement: $dbh::errstr\n";
    $sth->finish;
    $dbh->disconnect();
}
1;
