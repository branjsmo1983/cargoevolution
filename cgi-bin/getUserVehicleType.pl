use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

sub getUserVehicleType
{
    my $vt;
    my $userID=$_[0];
    my $PG_COMMAND=qq{SELECT vehicle_type FROM users3 WHERE id=?};
    
    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();
    
    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;
  
    
    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute( $userID )
        or die "Can't execute SQL statement: $dbh::errstr\n";
        
    my @row2 = $sth->fetchrow_array;
    if( (scalar @row2) != 0 )
    {
        # email found
        $vt = $row2[0];
    }
    else
    {
        $vt = undef;
    }
    
    $sth->finish;
    $dbh->disconnect();
    return $vt;

}
1;
