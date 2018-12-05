#!/usr/bin/perl

use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use CGI::Session;
use DBI;
use strict;
use warnings;

require "../cgi-bin/checkInputValidity.pl";
require "../cgi-bin/american2EuropeanData.pl";
require "../cgi-bin/european2AmericanData.pl";
require "../cgi-bin/getRegionIT.pl";
require "../cgi-bin/getProvinceIT.pl";
require "../cgi-bin/generatePGTimestamp.pl";
require "../cgi-bin/generateHTMLRedirectionButtons.pl";
require "../cgi-bin/generateHTMLInputForm.pl";
require "../cgi-bin/validateUserID.pl";
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/operationCompleted.pl";
require "../cgi-bin/isNull2Integer.pl";
require "../cgi-bin/limitDecimals.pl";
require "../cgi-bin/escapeTextForPostgres.pl";
require "../cgi-bin/updateTimeLastAction.pl";
require "../cgi-bin/selectUserMessagesFunct.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/alertUsersOfPossibleBusiness.pl";
require "../cgi-bin/getUserIDfromEmail.pl";
require "../cgi-bin/insertRegionalTrips.pl";

# print header (-charset => 'UTF-8');

my $q = CGI->new();

my $sid = $q->param('sid');
my $message_type = $q->param('message_type');
my $date_of_loading1 = $q->param('date_of_loading1');
my $date_of_loading2 = $q->param('date_of_loading2');
my $pick_up_region = $q->param('pick_up_region');
my $pick_up_province = $q->param('pick_up_province');
my $delivery_region = $q->param('delivery_region');
my $delivery_province = $q->param('delivery_province');
my $veihcle_type = $q->param('veihcle_type');
my $notes = $q->param('NotesArea');
my $demail = $q->param('demail');
my $status = 0;

# get the userID from the user session
my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});

# "from_admin"
my $from_admin = $session->param("from_admin");
my $username;

if( $demail )
{
  $username = getUserIDfromEmail( $demail );
}
else
{
  $username = $session->param("username");
}



# refresh time stamp of last action
updateTimeLastAction( $username );

# get token from user session
my $token_from_session = $session->param("token");
my $token_from_CGI = $session->param('token_face1');

# check if the User is enabled to insert messages to the database
my $user_enabled = validateUserID( $username, $sid );

if( $user_enabled eq "False" )
{
    # STUB: this can be handled in a  cuter way
    exit;
}

# convert the date format to the European one
 $date_of_loading1 = european2AmericanData( $date_of_loading1 );
 $date_of_loading2 = european2AmericanData( $date_of_loading2 );

# check the validity of inserted values
# my $MT = checkInputValidity("select", $message_type);
my $MT;

if( $message_type eq "0" )
{
   $MT = "False";
}
else
{
   $MT= "True";
}

my $DL1 = checkInputValidity("date", $date_of_loading1);

my $DL2 = 0;
if( $date_of_loading2 )
{
    $DL2 = checkInputValidity("date", $date_of_loading2);
}
else
{
    $DL2=1;
}

my $PUR = checkInputValidity("select", $pick_up_region);
my $DR  = checkInputValidity("select", $delivery_region);
my $PUP = checkInputValidity("select", $pick_up_province);
my $DP  = checkInputValidity("select", $delivery_province);
my $VT  = 1;

if( $delivery_province )
{}
else
{
    $delivery_province = 0;
}

if( $pick_up_province )
{}
else
{
    $pick_up_province = 0;
}


my $sth;
my $length=15.0;
my $weight=20.0;
my $bay_for_coils=0;
my $adr=0;
my $big_volume=0;

# get correct data from CGI
$length = $q->param('v_length');
$weight = $q->param('v_weight');

# check tha validity of the numeric inputs
$length = limitDecimals( $length );
$weight = limitDecimals( $weight );

$bay_for_coils = $q->param('coils');
$adr = $q->param('adr');
$big_volume = $q->param('big_volume');

# handle the boolean conditions
$bay_for_coils = isNull2Integer( $bay_for_coils );
$adr = isNull2Integer( $adr );
$big_volume = isNull2Integer( $big_volume );

# try to handle non valid data
if( $VT == 0 or $MT eq "False" or ($DR == 0 or $PUR == 0) )
{
    # pass all the fileds plus the  validity of them so that the routine can highlight the miscompiled fields
	#print "\$MT = $MT\n";
	#print "\$VT = $VT\n";
	# promotoe notes to UTF8
	#$notes=utf8::upgrade($notes);

    generateHTMLInputForm( "insert", $message_type, $MT,
				     $date_of_loading1, $DL1,
				     $date_of_loading2, $DL2,
				     $pick_up_region, $PUR,
				     $pick_up_province, $PUP,
				     $delivery_region, $DR,
				     $delivery_province, $PUR,
				     $veihcle_type, $VT,
				     $status, $length, $weight, $notes );
}

my @inputs = ("pick_up_region:$PUR", "delivery_region:$DR", "pick_up_province:$PUP", "delivery_province:$DP", "veihcle_type:$VT", "message_type:$MT", "date_loading1:$DL1", "date_loading2:$DL2" );
my %check_status = map { split( ":", $_, 2 ) } @inputs;

my $test_report="";

# foreach $key (keys %prices)
foreach my $key (keys %check_status )
{
    my $value = $check_status{$key};
    if( $value )
    {
        $test_report = "$test_report INFO(perl): Dati corretti $key\n";
        # print "value = $value\n";
    }
    else
    {
        $test_report = "$test_report ERROR(perl): Inserisci i dati correttamente nel campo $key\n";
        # print "value = $value\n";
    }
}


# print  $test_report ;
my $pup_string=getProvinceIT($pick_up_region, $pick_up_province);
# print "pick_up_province = $pick_up_province, $pup_string\n";
my $pur_string=getRegionIT( $pick_up_region );
# print "pick_up_region = $pick_up_region, $pur_string\n";
my $dp_string=getProvinceIT($delivery_region, $delivery_province);
# print "delivery_province = $delivery_province, $dp_string\n";
my $dr_string=getRegionIT( $delivery_region );
# print "delivery_region = $delivery_region, $dr_string\n";
# print "date_of_loading1 = $date_of_loading1\n";
# print "date_of_loading2 = $date_of_loading2\n";


if( $date_of_loading2 )
{

}
else
{
    # if the second date of loading was not inserted set it to the first one
    $date_of_loading2 = $date_of_loading1;
}

# generate timestamp to be stored in the message database
my $timestamp=generatePGTimestamp();
# add the message to the database of messages
# prepare postgres INSERT call

my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
  or die $DBI::errstr;

my $scal_notes= $dbh->quote($notes);

my $messages_table_name="messages2";
my $PGSQL_INSERT="INSERT into $messages_table_name(\"username\", \"message_type\", \"date_of_loading1\", \"date_of_loading2\", \"pick_up_region\", \"pick_up_province\", \"delivery_region\", \"delivery_province\", \"veihcle_type\", \"status\", \"creation_time\", \"country\", \"notes\")";
my $PGSQL_INSERT2=" values(\'$username\', \'$message_type\', \'$date_of_loading1\', \'$date_of_loading2\', \'$pur_string\', \'$pup_string\', \'$dr_string\', \'$dp_string\', \'$veihcle_type\', \'$status\', TIMESTAMP WITH TIME ZONE \'$timestamp\-07\', \'Italy\', $scal_notes)";


# print "$PGSQL_INSERT$PGSQL_INSERT2\n";
my $database_SQL_string="$PGSQL_INSERT$PGSQL_INSERT2 RETURNING id";

my $token_valid;

if( $token_from_session eq $token_from_CGI )
{
   $token_valid = "True";
}
else
{
   $token_valid = "False";
}

my $mid;


# write the message in the daabase only if all the required fields are correct
if( $VT != 0 and $MT eq "True" and ($DR != 0 and $PUR != 0) and $token_from_session eq $token_from_CGI )
{
   # change the token in the session to avoid multiple insertions
   my $new_token= rand(10000000);
   # save the token  into the user session
   $session->param("token", "$new_token");

   my $sth2 = $dbh->prepare($database_SQL_string)
        or die "Couldn't prepare statement: " . $dbh->errstr;

   my $retval = $sth2->execute( );
   if(!$retval)
   {
    # save to logfile
    my $path = "/home2/cargoevo";
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    $year += 1900;
    $mon++;
    my $currdate = "$mon$mday$year";

    my $logfile = $path . "/$currdate.log";
    open (OUT, ">>$logfile");
    print OUT "input.pl: SQL $database_SQL_string\n\n $dbh->errstr \n";
    close(OUT);
    die "Cannot insert user, $timestamp";
  }

   $sth = $sth2;
   # populate the vehicle details database
   my @row2 = $sth->fetchrow_array;
   if( (scalar @row2) != 0 )
   {
      $mid = $row2[0];
   }
   else
   {
      $mid = 0;
      exit;
   }

   my $PG_COMMAND="insert into vehicle_details(mid, length, weight, bay_for_coils, adr, big_volume) values(\'$mid\',\'$length\', \'$weight\', \'$bay_for_coils\', \'$adr\', \'$big_volume\' )";
   my $sth2 = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

   $sth2->execute()
        or die "Can't execute SQL statement: $dbh::errstr\n";

   $sth->finish;
   $dbh->disconnect();
}

# STUB complete the condition with all the required fileds
if( $VT != 0 and $MT eq "True" and ($DR != 0 and $PUR != 0) )
{

my $message;

if( $token_valid eq "True" )
{
   if( $sth )
   {
      $message="Messaggio inserito correttamente\n";
   }
   else
   {
      $message="Impossibile inserire il messaggio\n";
   }
}
else
{
   $message="Doppio inserimento evitato\n";
}

if( $mid )
{
    alertUsersOfPossibleBusiness( $mid );
    insertRegionalTrips($mid, $pur_string, $dr_string, $username, $username );
}

# operationCompleted( $sid, $message, "from_redirection");
selectUserMessagesFunct( $sid );

}
