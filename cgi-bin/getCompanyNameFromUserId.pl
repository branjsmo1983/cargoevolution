use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

sub getCompanyNameFromUserId
{
    # Reteive the emial of the user and generate the input form for the user
    my $company_name;
    my $userID=$_[0];
    my $PG_COMMAND=qq{SELECT company_name FROM users3 WHERE id=?};

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
        # $company_name found
        $company_name = $row2[0];
    }
    else
    {
        $company_name = undef;
    }

    $sth->finish;
    $dbh->disconnect();
    return $company_name;
}
1;
