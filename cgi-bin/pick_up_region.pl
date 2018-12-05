#!/usr/bin/perl -T
use CGI;
use strict;
use warnings;
require "../cgi-bin/generateHTMLSelectorProvinceIT.pl";

#print "Content-type: application/json\n\n";
# read the CGI params

use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
# print header;

my $cgi = CGI->new;
my $pick_up_region = $cgi->param("pick_up_region");
my $form_type = $cgi->param("form_type");

print $cgi->header(-type => "text/html", -charset => "utf-8");
print <<EOF;
<div>
<p>
Provincia Ritiro:&nbsp&nbsp&nbsp&nbsp
EOF
if( $form_type eq "insert" )
{
  generateHTMLSelectorProvinceIT( $pick_up_region, "pick_up_province" );
}
else
{
  generateHTMLSelectorProvinceIT( $pick_up_region, "pick_up_province", "from_select" );
}

print <<EOF;

</p>
</div>
EOF
