#!/usr/bin/perl

use CGI;
use strict;
use warnings;
require "../cgi-bin/generateHTMLSelectorRegionIT.pl";

my $cgi = CGI->new;
my $region = $cgi->param('region');
print $cgi->header(-type => "text/html", -charset => "utf-8");
print "<p>Regione: ";
generateHTMLSelectorRegionIT( "sel_reg", $region );
print "</p>\n";
