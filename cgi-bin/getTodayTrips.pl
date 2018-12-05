use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use Path::Class;
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/generatePGTimestamp.pl";
require "../cgi-bin/getVeihcleType.pl";
require "../cgi-bin/american2EuropeanData.pl";

sub getTodayTrips
{
  my $PG_COMMAND=qq{select pick_up_region, pick_up_province, delivery_region, delivery_province, veihcle_type  from messages2 where (date_of_loading1=? or date_of_loading2=?) and status='0'};

  my $database_name=getDatabaseName();
  my $db_username=getDatabaseUsername();
  my $db_pwd=getDatabasePwd();
  # get timestamp in the server ( server and client must be in the same timezone )
  my $timestamp = generatePGTimestamp();
  # get today's numberla date
  my @tmp = split(" ", $timestamp);
  my $today = $tmp[0];


  # connect to the database
  my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
     or die $DBI::errstr;


  my $sth = $dbh->prepare($PG_COMMAND)
    or die "Couldn't prepare statement: " . $dbh->errstr;

  $sth->execute( $today, $today )
      or die "Can't execute SQL statement: $dbh::errstr\n";

      my @row;
      my @trips;
      push @trips, american2EuropeanData($today);

      while(@row = $sth->fetchrow_array)
      {
        my $region1 = $row[0];
        my $province1 = $row[1];
        my $region2 = $row[2];
        my $province2 = $row[3];
        my $truck = $row[4];
        my $str_truck = getVeihcleType( $truck );

        push @trips, "Ritiro: $province1, Consegna: $province2, Tipologia mezzo: $str_truck";
      }
    return @trips;
}
1;
