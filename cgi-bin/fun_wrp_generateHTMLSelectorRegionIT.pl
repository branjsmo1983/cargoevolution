#!/usr/bin/perl
# Display dynamic contents on a web page
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
print header (-charset => 'UTF-8');
use Path::Class;

require "../cgi-bin/generateHTMLSelectorRegionIT.pl";

my $cgi = CGI->new;
my $region_d = $cgi->param("delivery_region");
my $region_p = $cgi->param("pick_up_region");


if ( $region_d eq "")
{

}
else
{
    generateHTMLSelectorRegionIT("delivery_region", $region_d );
}

if ( $region_p eq "")
{

}
else
{
    generateHTMLSelectorRegionIT("pick_up_region", $region_p );
}

