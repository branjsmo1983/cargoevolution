#!/usr/bin/perl

use CGI;
use strict;
use warnings;
require "../cgi-bin/generateHTMLSelectorProvinceIT.pl";

my $cgi = CGI->new;
my $pick_up_region = $cgi->param('region');
my $province = $cgi->param('province');

print $cgi->header(-type => "text/html", -charset => "utf-8");
print "<p>Provincia:";
generateHTMLSelectorProvinceIT( $pick_up_region, "sel_prov", $province );

print "</p>\n";
