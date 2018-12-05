use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/getUidFromMessageID.pl";
require "../cgi-bin/generatePGTimestamp.pl";
require "../cgi-bin/deltaTimePG.pl";

sub checkIfUserOnlineFromMid
{
    my $mid= $_[0];
    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();

    # get userID of the message
    my $uid = getUidFromMessageID( $mid );
    
    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;
  
    my $PG_COMMAND="select time_last_action from users3 where id=?";
    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute( $uid )
        or die "Can't execute SQL statement: $dbh::errstr\n";

    my @row = $sth->fetchrow_array;
    my $time_stamp_from_db = $row[0];

    my $time_stamp = generatePGTimestamp();
    my $dt_min = deltaTimePG($time_stamp, $time_stamp_from_db);

    $sth->finish;
    $dbh->disconnect();

    if( $dt_min > 15 )
    {
	return "False";
    }
    else
    {
        return "True";
    }
}
1;
