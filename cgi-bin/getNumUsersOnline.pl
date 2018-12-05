use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/generatePGTimestamp.pl";
require "../cgi-bin/deltaTimePG.pl";
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

sub getNumUsersOnline
{
    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();
 
    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;
  
    my $PG_COMMAND="select time_last_action from users3";
    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute()
        or die "Can't execute SQL statement: $dbh::errstr\n";

    my @row;
    my $time_stamp = generatePGTimestamp();

    my $cnt=0;

    while (@row = $sth->fetchrow_array) {
    
       my $time_stamp_from_db = $row[0];
       my $delta = deltaTimePG( $time_stamp ,$time_stamp_from_db);

       if( $delta < 15 )
       {
	  $cnt = $cnt +1;
       }
    }

    $sth->finish;
    $dbh->disconnect();

    return $cnt;
}
1;
