use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

sub checkMessageAvailability
{
    my $messageID = $_[0];
    
    # connect to the database
    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();
    
    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;
  
    my $PG_COMMAND="SELECT status FROM messages2 where id=?";
    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;
      
    $sth->execute( $messageID )
        or die "Can't execute SQL statement: $dbh::errstr\n";
    $sth->finish;
    
    my $ret;
    my @row2 = $sth->fetchrow_array;
    
    if( $row2[0] == 0 )
    {
        $ret = "True";
    }
    else
    {
        $ret = "False";
    }
    
    $sth->finish;
    $dbh->disconnect();
    
    return $ret;
}
1;
