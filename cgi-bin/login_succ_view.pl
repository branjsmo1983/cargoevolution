#!/usr/bin/perl
# Display dynamic contents on a web page
# run the C++ program to generate the HTML text file
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
print header (-charset => 'UTF-8');
use Path::Class;
use DBI;

require "../cgi-bin/italia.pl";
require "../cgi-bin/generateHTMLSelectorRegionIT.pl";
require "../cgi-bin/generateHTMLSelectorProvinceIT.pl";
require "../cgi-bin/american2EuropeanData.pl";
require "../cgi-bin/getVeihcleType.pl";
require "../cgi-bin/generateHTMLResultTable.pl";
require "../cgi-bin/generateHTMLInputForm.pl";

my $q = CGI->new();
my $sid = $q->param('sid');

generateHTMLInputForm("select", $sid);

