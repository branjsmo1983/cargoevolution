#!/usr/bin/perl -T
use CGI;
use strict;
use warnings;
require "../cgi-bin/generateHTMLSelectorProvinceIT.pl";

#print "Content-type: application/json\n\n";
# read the CGI params

use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);

my $cgi = CGI->new;
my $delivery_region = $cgi->param("delivery_region");
my $form_type = $cgi->param("form_type");


print $cgi->header(-type => "text/html", -charset => "utf-8");
print <<EOF;
<div>
<p>
Provincia Consegna:
EOF
if( $form_type eq "insert" )
{
  generateHTMLSelectorProvinceIT( $delivery_region, "delivery_province" );
}
else
{
  generateHTMLSelectorProvinceIT( $delivery_region, "delivery_province", "from_select"  );
}

print <<EOF;

</p>
</div>
EOF
