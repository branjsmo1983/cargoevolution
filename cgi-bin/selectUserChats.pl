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
require "../cgi-bin/generateHTMLResultTableChat.pl";
require "../cgi-bin/preparePGCondition.pl";
require "../cgi-bin/getRegionIT.pl";
require "../cgi-bin/postDBIexecute.pl";
require "../cgi-bin/preparePGConditionData.pl";
require "../cgi-bin/preparePGConditionProvince.pl";
require "../cgi-bin/preparePGConditionVehicle.pl";
require "../cgi-bin/validateUserID.pl";
require "../cgi-bin/generatePGTimestamp.pl";
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

my $q = CGI->new();
my $message_type = $q->param('message_type');
my $date_of_loading1 = $q->param('date_of_loading1');
my $date_of_loading2 = $q->param('date_of_loading2');
my $pick_up_region = $q->param('pick_up_region');
my $pick_up_province = $q->param('pick_up_province');
my $delivery_region = $q->param('delivery_region');
my $delivery_province = $q->param('delivery_province');
my $veihcle_type = $q->param('veihcle_type');
my $page_num = $q->param('page_num');
my $status = 0;

# get userID from user session
my $sid = $q->param('sid');
$session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $username = $session->param("username");
$session->param("last_action", "my_contacts");

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

my $messages_table_name="messages2";

my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;


# select all messages whose buyer is the current user
# $PG_COMMAND = "select * from $messages_table_name where buyerid=\'$username\' ";
# Working:
# $PG_COMMAND = "select DISTINCT  messages2.* from $messages_table_name  INNER JOIN chats ON (messages2.id = chats.mid and (chats.uid =? or chats.did =?))  order by date_of_loading1 DESC  ";
#$PG_COMMAND = "select foo.id, foo.username, foo.message_type, foo.creation_time, foo.date_of_loading1, foo.date_of_loading2, foo.country, foo.pick_up_region, foo.pick_up_province, foo.delivery_region, foo.delivery_province, foo.veihcle_type, foo.notes, foo.status, foo.buyerid, foo.nrequests, MAX(creation_time_chat) from (select  messages2.*, chats.creation_time as creation_time_chat from $messages_table_name  INNER JOIN chats ON (messages2.id = chats.mid and (chats.uid =? or chats.did =?))  order by chats.creation_time DESC) as foo GROUP by foo.id, foo.username, foo.message_type, foo.creation_time, foo.date_of_loading1, foo.date_of_loading2, foo.country, foo.pick_up_region, foo.pick_up_province, foo.delivery_region, foo.delivery_province, foo.veihcle_type, foo.notes, foo.status, foo.buyerid, foo.nrequests";

$PG_COMMAND = "select * from (select  messages2.id, messages2.username, messages2.message_type, messages2.creation_time, messages2.date_of_loading1, messages2.date_of_loading2, messages2.country, messages2.pick_up_region, messages2.pick_up_province, messages2.delivery_region, messages2.delivery_province, messages2.veihcle_type, messages2.notes, messages2.status, messages2.buyerid, messages2.nrequests,  MAX(chats.creation_time) as creation_time_chat from $messages_table_name  INNER JOIN chats ON (messages2.id = chats.mid and (chats.uid =? or chats.did =?)) GROUP BY messages2.id, messages2.username, messages2.message_type, messages2.creation_time, messages2.date_of_loading1, messages2.date_of_loading2, messages2.country, messages2.pick_up_region, messages2.pick_up_province, messages2.delivery_region, messages2.delivery_province, messages2.veihcle_type, messages2.notes, messages2.status, messages2.buyerid, messages2.nrequests) as foo  order by creation_time_chat DESC";

# decide the sorting scheme. The dafault is by date of loading
# $PG_COMMAND="$PG_COMMAND, messages2.id, messages2.username, messages2.message_type, messages2.creation_time, messages2.date_of_loading1, messages2.date_of_loading2, messages2.country, messages2.pick_up_region, messages2.pick_up_province, messages2.delivery_region, messages2.delivery_province, messages2.veihcle_type, messages2.notes, messages2.status, messages2.buyerid, messages2.nrequests";

$sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute( $username, $username )
        or die "Can't execute SQL statement: $dbh::errstr\n";

$session->flush();
$session->close();
#print $q->header("text/html");
generateHTMLResultTableChat( $sth, $sid, "Requests", $page_num);

$sth->finish;
$dbh->disconnect();
