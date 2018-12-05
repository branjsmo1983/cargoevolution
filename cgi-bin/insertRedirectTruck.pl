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
require "../cgi-bin/getAdminHash.pl";
require "../cgi-bin/getUidFromEmail.pl";
require "../cgi-bin/getRegionIT.pl";
require "../cgi-bin/european2AmericanData.pl";

my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

my $q = CGI->new();
my $sid = $q->param('sid');
my $uemail = $q->param('uemail');
my $date = $q->param('date_of_loading1');
$date = european2AmericanData( $date );
my $vehicle_type = $q->param('veihcle_type');
my $region = $q->param('pick_up_region');
my $dregion = $q->param('dregion');
my $region_str = getRegionIT( $region );
my $dregion_str = getRegionIT( $dregion );

my $usession = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $uid = $usession->param('username');

my $did = getUidFromEmail( $uemail );
# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
   or die $DBI::errstr;

my $PG_COMMAND="insert into trucks(uid, vehicle_type, region, day, dregion) values(?, ?, ?, ?, ?)";
my $sth = $dbh->prepare($PG_COMMAND)
    or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute($did, $vehicle_type, $region_str, $date, $dregion_str )
    or die "Couldn't execute statement: " . $dbh->errstr;

$sth->finish;
$dbh->disconnect();

print $q->redirect("insertTruck.pl?sid=$sid");
