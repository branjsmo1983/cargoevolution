#!/usr/bin/perl
# Display dynamic contents on a web page
# run the C++ program to generate the HTML text file
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
print header (-charset => 'UTF-8');
use Path::Class;

require "../cgi-bin/italia.pl";
require "../cgi-bin/generateHTMLSelectorRegionIT.pl";
require "../cgi-bin/generateHTMLSelectorProvinceIT.pl";
require "../cgi-bin/generateHTMLInputForm.pl";
require "../cgi-bin/generateHTMLInputFormAdmin.pl";

generateHTMLInputFormAdmin("insert");
