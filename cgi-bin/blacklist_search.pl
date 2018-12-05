#!/usr/bin/perl

use cPanelUserConfig;
use CGI;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use Path::Class;
use strict;

use DBI;
use DBD::Pg;
use DBD::Pg qw(:pg_types);

require "../cgi-bin/searchCompany.pl";

my $cgi = CGI->new;
my $key = $cgi->param('key_value');

my $num_char = length( $key );
my $json;

if(  $num_char >= 3 )
{
  my @v_res = searchCompany( $key );

  my $results=join("|", @v_res);
  $json = qq{{"success" : "search was successfull", "results" : "$results"}};
}
else
{
  $json = qq{{"results" : "Il numero minimo di caratteri è 3", "search_block" : "search_block"}};
}


print $cgi->header(-type => "application/json", -charset => "utf-8");
print $json;

