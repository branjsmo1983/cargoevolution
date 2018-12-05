use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

sub getUserIDfromEmail
{
    my $email=$_[0];
    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();

    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;
  
    my $PG_COMMAND="select id from users3 where email=?";
    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute( $email )
        or die "Can't execute SQL statement: $dbh::errstr\n";

    my @row;
    @row = $sth->fetchrow_array;
    my $id=$row[0];

    $sth->finish;
    $dbh->disconnect();

    return $id;
}
1;
