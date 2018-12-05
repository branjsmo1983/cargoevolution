#!/usr/bin/perl

use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use DBD::Pg;
use DBD::Pg qw(:pg_types);
use strict;
use Fcntl qw(:flock SEEK_END);
use File::Slurp;
use File::Basename;
use Digest::MD5;
use Encode;
use Date::Calc qw(Day_of_Week );

use strict;
use warnings;

require "deltaTimePG.pl";
require "generatePGTimestamp.pl";
require "checkIfUserOnlineFromMid.pl";
require "getPhoneNumbers.pl";
require "generateTempHTMLpageForFeedBack.pl";
require "generatePGTimestamp.pl";
require "../cgi-bin/searchCompany.pl";
require "../cgi-bin/sendEmailFunct.pl";
require "../cgi-bin/generateHTMLSelectorProvinceIT.pl";
require "../cgi-bin/getTodayTrips.pl";
require "../cgi-bin/getTomorrowTrips.pl";
require "limitDecimals.pl";

my @trips = getTodayTrips();
my $mailBody;

foreach my $trip (@trips)
{
  # print "$trip\n";
  my $tmp_string = sprintf("%s\n", $trip);
  $mailBody = $mailBody.$tmp_string;
}

# getTomorrowTrips
@trips = getTomorrowTrips();
$mailBody;

foreach my $trip (@trips)
{
  # print "$trip\n";
  my $tmp_string = sprintf("%s\n", $trip);
  $mailBody = $mailBody.$tmp_string;
}

print $mailBody;

my $dow = Day_of_Week("2017","10","28");
print "\$dow = $dow\n";
my $dow = Day_of_Week("2017","10","29");
print "\$dow = $dow\n";
$dow = Day_of_Week("2017","10","30");
print "\$dow = $dow\n";

my $str = " Mario Rossi    ";
$str =~ s/^\s+|\s+$//g;

print "\$str=\"$str\"\n";
# print "==========================\n";
#print "@trips\n";

#sendEmailFunct("info\@prolocosalt.it", "test skype", "Prova notifica Skype");
# generateHTMLSelectorProvinceIT( 1, "pick_up_province", 1, "dsds" );


#my $mid = "08bb38be16c0fd9f94664e36b42c8b94";
#my $uid = "dac48391dbd472e8e96446583a655ea0";
#my $tmp_file = generateTempHTMLpageForFeedBack( $uid, $mid );
#print "\$tmp_file = $tmp_file\n";
