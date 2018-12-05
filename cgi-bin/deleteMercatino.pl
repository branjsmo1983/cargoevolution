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

my $q = CGI->new();
my $referer = $ENV{HTTP_REFERER};
print $q->redirect(-uri => $referer);
print header (-charset => 'UTF-8');
my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();


my $mid = $q->param('mid');
my $sid = $q->param('sid');

my $usession = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $uid = $usession->param('username');

my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();


# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
   or die $DBI::errstr;

my $PG_COMMAND = "DELETE FROM mercatino WHERE id = ? ";

my $sth = $dbh->prepare($PG_COMMAND)
    or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute( $mid )
    or die "Couldn't execute statement: " . $dbh->errstr;

$sth->finish;
$dbh->disconnect();

#print $q->redirect("generateHTMLMercatino.pl?sid=$sid");

