use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;
use utf8;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
use Digest::MD5;
use Encode;
use FileHandle;


sub checkDurcExistenceTime
{

    my $uid=$_[0];
    my $PG_COMMAND=qq{SELECT pdf, creation_time FROM durc WHERE uid=? order by creation_time DESC};

    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();

    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;


    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;


    $sth->execute( $uid ) or die "Can't execute SQL statement: $dbh::errstr\n";
    my $durc;

    my @row2 = $sth->fetchrow_array;
    if( (scalar @row2) != 0 )
    {

      $durc = $row2[1];
    }
    else
    {
        $durc = "False";
    }

    $sth->finish;
    $dbh->disconnect();
    return $durc;
}
1;
