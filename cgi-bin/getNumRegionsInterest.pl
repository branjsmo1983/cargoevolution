use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use Path::Class;
use DBI;
use DBD::Pg;
use DBD::Pg qw(:pg_types);
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/getTripInformationFromMID.pl";
require "../cgi-bin/getEmailFromUserID.pl";

sub getNumRegionsInterest
{
  my $uid = $_[0];

  my $database_name=getDatabaseName();
  my $db_username=getDatabaseUsername();
  my $db_pwd=getDatabasePwd();

  # connect to the database
  my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
     or die $DBI::errstr;

  my $PG_COMMAND = "select COUNT(region) from regions where uid=?";

  my $sth = $dbh->prepare($PG_COMMAND)
    or die "Couldn't prepare statement: " . $dbh->errstr;

  $sth->execute( $uid )
      or die "Can't execute SQL statement SELECT: $dbh::errstr\n";

  my @row =  $sth->fetchrow_array;
  my $num_regions = $row[0];

  $sth->finish;
  $dbh->disconnect();
}
1;
