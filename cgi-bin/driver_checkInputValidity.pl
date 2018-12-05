#!/usr/bin/perl

use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/checkInputValidity.pl";
require "../cgi-bin/american2EuropeanData.pl";
require "../cgi-bin/european2AmericanData.pl";
require "../cgi-bin/generatePGTimestamp.pl";

my $date1="2017-02-23";
$date1 = american2EuropeanData( $date1 );
my $ret = checkInputValidity("date", $date1);

my $date2="12/02/2017";
$date2 = european2AmericanData( $date2 );

my $timestamp=generatePGTimestamp();
print "timestamp = $timestamp\n";
