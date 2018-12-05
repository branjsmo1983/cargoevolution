use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/media.pl";

sub feedDB
{
    my $mid=$_[0];
    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();

    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;

    my $PG_COMMAND="select score from feedback where userid_of=?";
    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute( $mid )
        or die "Can't execute SQL statement: $dbh::errstr\n";

    my @row;
    my @feedTot;
    my $media_finale;
    while(@row = $sth->fetchrow_array){
	     my $elemento = $row[0];
	     push @feedTot, $elemento;
	  }
	  $media_finale=media(@feedTot);
    $sth->finish;
    $dbh->disconnect();

    return $media_finale;
}
1;
