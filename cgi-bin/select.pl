#!/usr/bin/perl

use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
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
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/isNull2Integer.pl";
require "../cgi-bin/updateTimeLastAction.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/limitDecimals.pl";
require "../cgi-bin/getUserVehicleType.pl";

my $q = CGI->new();

my $message_type = $q->param('message_type');
my $date_of_loading1 = $q->param('date_of_loading1');
my $date_of_loading2 = $q->param('date_of_loading2');


my $pick_up_region = $q->param('pick_up_region');
my $pick_up_province = $q->param('pick_up_province');

if( $pick_up_region == 0 )
{
  $pick_up_province = 0;
}

my $delivery_region = $q->param('delivery_region');
my $delivery_province = $q->param('delivery_province');

if( $delivery_region == 0 )
{
  $delivery_province = 0;
}

my $veihcle_type = $q->param('veihcle_type');
my $min_length = $q->param('v_length');
my $max_weight = $q->param('v_weight');

$min_length = limitDecimals( "$min_length" );
$max_weight = limitDecimals( "$max_weight" );
# print "\$max_weight = $max_weight\n";

# get userID from user session
my $sid = $q->param('sid');
$session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $username = $session->param("username");
$session->param("last_action", "my_search");

# refresh time stamp of last action
updateTimeLastAction( $username );
my $user_vehicle_types = getUserVehicleType( $username );
# filter also according to ADR category
my $adr = $q->param('adr');
$adr = isNull2Integer( $adr );

my $coils = $q->param('coils');
$coils = isNull2Integer( $coils );

my $big_volume = $q->param('big_volume');
$big_volume = isNull2Integer( $big_volume );

my $status = 0;

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

# POSTGRES QUERY COMMAND
#
my $PG_COMMAND=qq{SELECT * FROM $messages_table_name RIGHT OUTER JOIN vehicle_details ON (vehicle_details.mid = messages2.id)};
my $options;
my $sth;

my $pup_region_str= getRegionIT($pick_up_region);
my $pup_condition = preparePGCondition( $pick_up_region );


if( $pup_condition ne "skip" )
{
    my $tmp=" WHERE pick_up_region=?";
    $PG_COMMAND="$PG_COMMAND $tmp";
    $tmp = "$pup_condition:";
    $options="$options$tmp";
}
else
{
    $pup_condition = " IS NOT NULL ";
    my $tmp=" WHERE pick_up_region $pup_condition";
    $PG_COMMAND="$PG_COMMAND $tmp";
}

my $del_region_str= getRegionIT($delivery_region);
my $del_condition = preparePGCondition( $delivery_region );


if( $del_condition ne "skip" )
{
    my $tmp=" and delivery_region=?";
    $PG_COMMAND="$PG_COMMAND $tmp";
    $tmp = "$del_condition:";
    $options="$options$tmp";
}
else
{
    $del_condition = " IS NOT NULL ";
    my $tmp=" and delivery_region $del_condition";
    $PG_COMMAND="$PG_COMMAND $tmp";
}
# handle privinces
my $ppro_region_str= getProvinceIT($pick_up_region, $pick_up_province);
my $ppro_condition = preparePGConditionProvince( $pick_up_region, $pick_up_province );


if( $ppro_condition ne "skip" )
{
    my $tmp=" and pick_up_province=?";
    $PG_COMMAND="$PG_COMMAND $tmp";
    $tmp = "$ppro_condition:";
    $options="$options$tmp";
}
else
{
    $ppro_condition = " IS NOT NULL ";
    my $tmp=" and pick_up_province $ppro_condition";
    $PG_COMMAND="$PG_COMMAND $tmp";
}

my $pdel_region_str= getProvinceIT($delivery_region, $delivery_province);
my $pdel_condition = preparePGConditionProvince( $delivery_region, $delivery_province );


if( $pdel_condition ne "skip" )
{
    my $tmp=" and delivery_province=?";
    $PG_COMMAND="$PG_COMMAND $tmp";
    $tmp = "$pdel_condition:";
    $options="$options$tmp";
}
else
{
    $pdel_condition = " IS NOT NULL ";
    my $tmp=" and delivery_province $pdel_condition";
    $PG_COMMAND="$PG_COMMAND $tmp";
}

my $pupdate_str= $date_of_loading1;
my $pupdate_condition = preparePGConditionData( $date_of_loading1 );
my $pupdate_condition2 = preparePGConditionData( $date_of_loading2 );

if( $pupdate_condition2 eq "skip" )
{
    $pupdate_condition2 = $pupdate_condition;
}
else
{

}

if( $pupdate_condition ne "skip" )
{
    my $tmp=" and (date_of_loading1=? or date_of_loading2=\'$pupdate_condition\'::date or date_of_loading1=\'$pupdate_condition2\'::date or date_of_loading2=\'$pupdate_condition2\'::date ) ";
    $PG_COMMAND="$PG_COMMAND $tmp";
    $tmp = "$pupdate_condition:";
    $options="$options$tmp";
}
else
{
    $pupdate_condition = "$today";
    my $tmp=" and date_of_loading1 >= \'$pupdate_condition\'::date ";
    $PG_COMMAND="$PG_COMMAND $tmp";
}

my $message_type_str= $message_type;
my $message_type_condition = preparePGConditionData( $message_type );


if( $message_type_condition ne "skip" )
{
    my $tmp=" and message_type=?";
    $PG_COMMAND="$PG_COMMAND $tmp";
    $tmp = "$message_type_condition:";
    $options="$options$tmp";
}
else
{
    $message_type_condition = " IS NOT NULL ";
    my $tmp=" and message_type $message_type_condition";
    $PG_COMMAND="$PG_COMMAND $tmp";
}

my $vehicle_type_str= $veihcle_type;
my $vehicle_type_condition = ( $veihcle_type );


if( $vehicle_type_condition != 0 )
{
    my $tmp=" and veihcle_type=?";
    $PG_COMMAND="$PG_COMMAND $tmp";
    $tmp = "$vehicle_type_condition:";
    $options="$options$tmp";
}
else
{
    $vehicle_type_condition = " IS NOT NULL $vehicle_type";
    my $tmp=" and veihcle_type $vehicle_type_condition";
    $PG_COMMAND="$PG_COMMAND $tmp";
}

# do not show my mdate_of_loading2essages
my $tmp=" and username!=? ";
$PG_COMMAND="$PG_COMMAND $tmp";
$tmp = "$username:";
$options="$options$tmp";

# filter also on the size of the vehicle
$tmp=" and vehicle_details.length<=?";
$PG_COMMAND="$PG_COMMAND $tmp";
$tmp = "$min_length:";
$options="$options$tmp";

# filter also on the  maximum weight
# $max_weigh
$tmp=" and vehicle_details.weight<=?";
$PG_COMMAND="$PG_COMMAND $tmp";
$tmp = "$max_weight:";
$options="$options$tmp";

# do not show the bidding phase in this section
$tmp=" and messages2.status='0'";
$PG_COMMAND="$PG_COMMAND $tmp";

# filter out the results containing veichle types not owned by the user
# $veihcle_type variable from input form
# $user_vehicle_types
my @vt_array = split('#', $user_vehicle_types);
# insert the fake vehicle type 7 (Centinato o aperto)
splice @vt_array, 6, 0, '0';
my @nzel;

for($i=0; $i < scalar @vt_array; $i++ )
{
  my $item = $vt_array[$i];
  if( "$item" ne "0"  )
  {
    push @nzel, ($i+1);
  }
}

my $vehicle_query;

for($i=0; $i < (scalar @nzel) -1; $i++ )
{
  my $tmp1= sprintf("\'%d\', ", $nzel[$i]);
  $vehicle_query = "$vehicle_query$tmp1";
}

my $idx2 = (scalar @nzel) -1;
my $tmp1= sprintf("\'%d\'", $nzel[$idx2]);
$vehicle_query = "$vehicle_query$tmp1";

if( $vehicle_query =~ /1\'|2\'/ )
{
   $vehicle_query = "$vehicle_query, \'7\'";
}

# check if the user has fridge
if( $vehicle_query =~ /3/ )
{
  $vehicle_query = $vehicle_query.", \'1\'";
}
$vehicle_query = $vehicle_query.",\'0\', \'1\', \'2\', \'3\', \'4\', \'5\', \'6\', \'7\'";
$tmp=" and messages2.veihcle_type  IN ( $vehicle_query )";
$PG_COMMAND="$PG_COMMAND $tmp";

# filter by ADR category
if( $vt_array[9] == 0)
{
   $tmp=" and vehicle_details.adr=\'0\'";
}
else
{
   $tmp="";
}

$PG_COMMAND="$PG_COMMAND $tmp";


# filter by coils
if( $vt_array[8] == 0)
{
   $tmp=" and vehicle_details.bay_for_coils=\'0\'";
}
else
{
   $tmp="";
}
$PG_COMMAND="$PG_COMMAND $tmp";

if( $vt_array[7] == 0)
{
   $tmp=" and vehicle_details.big_volume=\'0\'";
}
else
{
   $tmp="";
}
$PG_COMMAND="$PG_COMMAND $tmp";

# filter by big_volume


#print "$tmp\n";

# do not show messages if the user is in the blacklist (STUB not safe)
$tmp=" and messages2.username NOT IN (SELECT uid FROM blacklist where uid2block=\'$username\' )";
$PG_COMMAND="$PG_COMMAND $tmp";

# decide the sorting scheme. The dafault is by date of loading
$PG_COMMAND="$PG_COMMAND order by date_of_loading1 ASC, vehicle_details.length ASC";

$sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

# save query into user session
$session->param("pgcommand", $PG_COMMAND);
$session->param("pgoptions", $options);
$session->flush();
$session->close();

# need to execute with variable number of options
postDBIexecute( $sth, $options );

#print $q->header("text/html");
generateHTMLResultTable( $sth, $sid );
#print "<p> $ppro_region_str,  $ppro_condition, $pick_up_region, $pick_up_province\n</p>\n";

$sth->finish;
$dbh->disconnect();
