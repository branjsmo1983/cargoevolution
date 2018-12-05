use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

sub getUidFromEmail
{
    # Reteive the emial of the user and generate the input form for the user
    my $uid;
    my $email=$_[0];
    $email =~ s/^\s+|\s+$//g;
    my $PG_COMMAND=qq{SELECT id FROM users3 WHERE email=?};

    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();

    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;


    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute( $email )
        or die "Can't execute SQL statement: $dbh::errstr\n";

    my @row2 = $sth->fetchrow_array;
    if( (scalar @row2) != 0 )
    {
        # email found
        $uid = $row2[0];
    }
    else
    {
        $uid = undef;
    }

    $sth->finish;
    $dbh->disconnect();
    return $uid;
}
1;
