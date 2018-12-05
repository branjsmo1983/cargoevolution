#!/usr/bin/perl

use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use Path::Class;
use DBI;

require "../cgi-bin/generateHTMLInputForm.pl";
require "../cgi-bin/getRegionNum.pl";
require "../cgi-bin/getProvinceNum.pl";
require "../cgi-bin/american2EuropeanData.pl";

my $q = CGI->new();
my $sid = $q->param('sid');
my $mid = $q->param("mid");

# get the maeesage ID to edit
#my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});

my $messages_table_name="messages2";

my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
  or die $DBI::errstr;

# POSTGRES QUERY COMMAND
# 
my $PG_COMMAND=qq{SELECT * FROM $messages_table_name RIGHT OUTER JOIN vehicle_details ON (vehicle_details.mid = messages2.id) where messages2.id = ?};


$sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute($mid);

# generate the page to edit the data in the database
# only one message has  certain id
my @row = $sth->fetchrow_array;

print $q->header("text/html");

#my $cnt=0;
#my $nel = scalar @row;
#for($cnt=0; $cnt<$nel; $cnt=$cnt+1 )
#{
#   my $el= $row[$cnt];
#   print "\$row[$cnt] = $el\n";
#}

my $message_type = $row[2];
my $MT = "True";
my $date_of_loading1 = $row[4];
$date_of_loading1 = american2EuropeanData( $date_of_loading1 );
my $DL1 = "True";
my $date_of_loading2 = $row[5];
$date_of_loading2 = american2EuropeanData( $date_of_loading2 );
my $DL2 = "True";
my $pick_up_region = $row[7];

my $pur_index = getRegionNum( $pick_up_region );

my $PUR = "True";
my $pick_up_province = $row[8];
my $PUP = "True";

my $pup_index = getProvinceNum($pur_index, $pick_up_province);

my $delivery_region=$row[9];

my $dr_index = getRegionNum( $delivery_region );
my $DR = "True";
my $delivery_province = $row[10];

my $dp_index = getProvinceNum($dr_index, $delivery_province);

my $DP= "True";
my $veihcle_type = $row[11];


my $VT = "True";
my $arg_status=$row[13];
my $arg_length = $row[18];
my $arg_weight = $row[19];
my $arg_bay_for_coils = $row[20];
my $arg_adr = $row[21];
my $arg_big_volume = $row[22];
my $arg_notes =   $row[12];

# print "\$pick_up_region = $pick_up_region\n";
# print "\$pick_up_province = $pick_up_province\n";
# we need to retrieve the region and province numbers from the names written in strings

generateHTMLInputForm( "insert", $sid, $message_type, $date_of_loading1, $DL1, $date_of_loading2, $DL2, $pur_index, $PUR, $pup_index, $PUP, $dr_index, $DR, $dp_index, $DP, $veihcle_type, $VT, $arg_status, $arg_length, $arg_weight, $arg_notes, $arg_bay_for_coils, $arg_adr,  $arg_big_volume, "from_edit", $mid  );


