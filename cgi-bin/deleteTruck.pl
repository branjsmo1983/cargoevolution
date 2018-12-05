#!/usr/bin/perl

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
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
require "../cgi-bin/generateHTMLheader.pl";
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/validateUserID.pl";
require "../cgi-bin/getAdminHash.pl";
require "../cgi-bin/generatePGTimestamp.pl";
require "../cgi-bin/american2EuropeanData.pl";
require "../cgi-bin/generateHTMLopenTag.pl";
require "../cgi-bin/getVeihcleType.pl";
require "../cgi-bin/generateHTMLSelectorRegionIT.pl";
require "../cgi-bin/getVeihcleType.pl";
require "../cgi-bin/getRegionIT.pl";
require "../cgi-bin/getEmailFromUserID.pl";
require "../cgi-bin/european2AmericanData.pl";

my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

my $q = CGI->new();
my $sid = $q->param('sid');
my $date1 = $q->param('day');
my $date = european2AmericanData( $date1 );
my $vehicle_type = $q->param('vname');
my $region = $q->param('region');
my $dregion = $q->param('dregion');
my $user = $q->param('uid');
my $region_str = getRegionIT( $region );
my $dregion_str = getRegionIT( $dregion );
my $tid = $q->param('tid');

my $usession = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $uid = $usession->param('username');

my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();


# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
   or die $DBI::errstr;

#my $PG_COMMAND="insert into trucks(uid, vehicle_type, region, day, dregion) values(?, ?, ?, ?, ?)";
#my $PG_COMMAND="UPDATE messages2 SET status = '-1' WHERE id = ?";
#my $PG_COMMAND = "DELETE FROM trucks WHERE uid = ? AND vehicle_type = ? AND region = ?
# AND day = ? AND dregion = ? ";
#say 'query da eseguire : ';
#say $PG_COMMAND ;
my $PG_COMMAND = "DELETE FROM trucks WHERE id = ? ";

my $sth = $dbh->prepare($PG_COMMAND)
    or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute( $tid )
    or die "Couldn't execute statement: " . $dbh->errstr;

$sth->finish;
$dbh->disconnect();

print $q->redirect("insertTruck.pl?sid=$sid");
