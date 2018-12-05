use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

sub getNumUsersOnlineFile
{
  my $PG_COMMAND=qq{SELECT num FROM num_users };

  my $database_name=getDatabaseName();
  my $db_username=getDatabaseUsername();
  my $db_pwd=getDatabasePwd();

  # connect to the database
  my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
     or die $DBI::errstr;


  my $sth = $dbh->prepare($PG_COMMAND)
    or die "Couldn't prepare statement: " . $dbh->errstr;

  $sth->execute( )
        or die "Can't execute SQL statement: $dbh::errstr\n";

  my @row2 = $sth->fetchrow_array;
  my $num_users = $row2[0] + 10;

  $sth->finish;
  $dbh->disconnect();
  return $num_users;
}
1;
