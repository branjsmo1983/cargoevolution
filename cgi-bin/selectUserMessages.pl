#!/usr/bin/perl

use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Session;
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
use Path::Class;
use DBI;

require "../cgi-bin/italia.pl";
require "../cgi-bin/generateHTMLSelectorRegionIT.pl";
require "../cgi-bin/generateHTMLSelectorProvinceIT.pl";
require "../cgi-bin/american2EuropeanData.pl";
require "../cgi-bin/getVeihcleType.pl";
require "../cgi-bin/generateHTMLResultTable.pl";
require "../cgi-bin/preparePGCondition.pl";
require "../cgi-bin/getRegionIT.pl";
require "../cgi-bin/postDBIexecute.pl";
require "../cgi-bin/preparePGConditionData.pl";
require "../cgi-bin/preparePGConditionProvince.pl";
require "../cgi-bin/preparePGConditionVehicle.pl";
require "../cgi-bin/validateUserID.pl";
require "../cgi-bin/generatePGTimestamp.pl";
require "../cgi-bin/updateTimeLastAction.pl";
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

my $q = CGI->new();
my $status = 0;

# get userID from user session
my $sid = $q->param('sid');
my $page_num = $q->param('page_num');
$session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $username = $session->param("username");
$session->param("last_action", "my_trips");
# refresh time stamp of last action
updateTimeLastAction( $username );

my $user_enabled = validateUserID( $username, $sid );

# get timestamp in the server ( server and client must be in the same timezone )
my $timestamp = generatePGTimestamp();
# get today's numberla date
my @tmp = split(" ", $timestamp);
my $today = $tmp[0];

if( $user_enabled eq "False" )
{
    # STUB: this can be handled in a  cuter way
    exit;
}

# generate the token and save it into the session
my $token= rand(10000000);
$session->param("token", "$token");
$session->param("token_face1", "$token");

my $messages_table_name="messages2";

my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;


# select all messages from the calling user (it is to decide whether or not to leave the filters from the input page)
$PG_COMMAND = "select * from $messages_table_name where username=\'$username\' and status!=\'-1\' and status!=\'-2\' and status!=\'-3\' ";
# decide the sorting scheme. The dafault is by date of loading
$PG_COMMAND="$PG_COMMAND order by date_of_loading1 DESC";

$sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

# need to execute with variable number of options
postDBIexecute( $sth, $options );


$session->flush();
$session->close();
#print $q->header("text/html");
generateHTMLResultTable( $sth, $sid, "viewOnly", $page_num );

$sth->finish;
$dbh->disconnect();
