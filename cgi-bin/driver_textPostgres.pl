#!/usr/bin/perl

use File::Basename;
use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;
use utf8;

require "../cgi-bin/escapeTextForPostgres.pl";
require "../cgi-bin/getTripInformationFromMID.pl";
require "../cgi-bin/read_file_STUB.pl";
require "../cgi-bin/getFeedbackFromUserID.pl";
require "../cgi-bin/generateTempHTMLpageForTransactionCompleted.pl";
require "../cgi-bin/getTripInformationFromMID.pl";
require "../cgi-bin/generatePGTimestamp.pl";
require "../cgi-bin/insertMessageChat.pl";

my $input="Il ritorno dell'acquila L'Aquila è qui!";
my $output = escapeTextForPostgres( $input );

print "\$input = $input\n";
print "\$output = $output\n";

my ($a, $b, $c) = fileparse("/tmp/lslsls.dat", ".dat");
print "$a\n";
print "$b\n";
print "$c\n";


my $trip_details;

$trip_details = getTripInformationFromMID("a10b7ce5af2d23dfbbb8ae8933298ae4");
print "\$trip_details:\n $trip_details\n";

my $filename="/tmp/a.html";

my $fileContents=read_file_STUB( $filename );

#print "\$fileContents:\n$fileContents\n";

my $feedBack=getFeedbackFromUserID("dac48391dbd472e8e96446583a655ea0");
print "\$feedBack:\n$feedBack\n";


my $tt1 = getTripInformationFromMID("2842f9e10f1bf1a282b754e85d95be3f");
utf8::encode( $tt1 );
print "\$tt1:\n$tt1\n";
my $tt2 = getTripInformationFromMID("2842f9e10f1bf1a282b754e85d95be3f");
print "\$tt2:\n$tt2\n";
# generateTempHTMLpageForTransactionCompleted("a10b7ce5af2d23dfbbb8ae8933298ae4", "dac48391dbd472e8e96446583a655ea0", "ffeeb11829780a0b59e7f34472be44c4");
my $uid="d9bc3c4f68fa9f9fbd4c83e68e272eb1";
my $mid="31baace0dbc96a8329a5462f53d70f0b";
my $timestamp=generatePGTimestamp();
my $text="Hello World!";


my $id = insertMessageChat( $mid, $uid, $timestamp, $text );
print "\$id=$id\n";


my $vehicle_type_str = "1#1#1#1#0#1#0#1#1#";

$vehicle_type_str =~ s/1/checked/g;
$vehicle_type_str =~ s/0/ /g;

my @v_c = split("#", $vehicle_type_str);
my $size = scalar( @v_c );

print "@v_c\n";
print "\$size: $size\n";

