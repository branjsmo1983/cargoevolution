#!/usr/bin/perl

use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use Path::Class;

my $cgi = CGI->new;

# create a new session that expires after 1hour
my $usession = new CGI::Session("driver:File", undef, {Directory=>"/tmp"});
my $sid = $usession->id();
$usession->param("_logged_in", "1");
$usession->expire('_logged_in','1h');
# generate the token and save it into the session
my $token= rand(10000000);
#print "\$token\n$token";
# save the token  into the user session
$usession->param("token", "$token");
$usession->param("token_face1", "$token");

# create a JSON string according to the database result, send back also the session ID
my $json = ($usession) ? 
  qq{{"success" : "login is successful", "sid" : "$sid"}} : 
  qq{{"error" : "Non riesco a generare una sessione utente"}};


print $cgi->header(-type => "application/json", -charset => "utf-8");
print $json;
