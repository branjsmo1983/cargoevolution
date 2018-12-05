#!/usr/bin/perl -T
use cPanelUserConfig;
use CGI;
use CGI::Session;
use DBI;
use URI::Escape;
use strict;
use warnings;


#print "Content-type: application/json\n\n";
# read the CGI params

use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
use Net::Whois::IP qw(whoisip_query);
use Data::Validate::IP qw(is_private_ip is_linklocal_ipv4 is_loopback_ipv4);

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

my $cgi = CGI->new;
my $username = $cgi->param("username");
my $password = $cgi->param("password");

my $IP_client = $cgi->remote_addr();
my $optional_multiple_flag;
my $option_array_of_search_options;
my $IP_in_EU = "False";

# check if IP is of a private network
if( is_loopback_ipv4( $IP_client ) )
{
  $IP_in_EU = "True";
}
else
{
  my ($response,$array_of_responses) = whoisip_query($IP_client,$optional_multiple_flag,$option_array_of_search_options);
  # allow only users in the EU
  foreach (sort keys(%{$response}) )
  {

     #print "$_ $response->{$_} \n";
     if(  $response->{$_}  =~ /IT|BE|EL|LT|PT|BG|ES|LU|RO|CZ|FR|HU|SI|DK|HR|MT|SK|DE|IT|NL|FI|EE|CY|AT|SE|IE|LV|PL|UK/i and $_ eq "country"  )
     {
       $IP_in_EU = "True";
     }
  }
}

# connect to the database
my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
  or die $DBI::errstr;

# check the username and password in the database
my $statement = qq{SELECT id, enabled, username, feedback, privacy, conditions FROM users3 WHERE username=? and password=?};
my $sth = $dbh->prepare($statement)
  or die $dbh->errstr;
$sth->execute($username, $password)
  or die $sth->errstr;

my @row = $sth->fetchrow_array;
my ($userID) = $row[0];
my ($enabled) = $row[1];
my $name = $row[2];
my $feedback = $row[3];
my $privacy = $row[4];
my $conditions = $row[5];

# create a user session
my $usession = new CGI::Session("driver:File", undef, {Directory=>"/tmp"});
my $sid = $usession->id();
# save user ID into the session so it is not necessary to pass the UserID
$usession->param("username", $userID);
$usession->param("name", $name);
$usession->param("feedback", $feedback);
$usession->param("_logged_in", "1");
$usession->param("privacy", $privacy);
$usession->param("conditions", $conditions);
$usession->expire('_logged_in','23h');

# create a JSON string according to the database result, send back also the session ID
my $json = ($userID) ?
  qq{{"success" : "login is successful", "sid" : "$sid"}} :
  qq{{"error" : "username o password errate"}};

if(  $userID  )
{

}
else
{
   my $filename = '/home2/cargoevo/tmp/report.txt';
   open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";
   print $fh "Username: $username, password: $password\n";
   close $fh;
}

# make sure that the account is active
if( ("$enabled") eq "0" )
{
    $json = qq{{ "error" : "Account scaduto" }};
}

if( $IP_in_EU ne "True" )
{
    #$json = qq{{ "error" : "Il tuo IP risulta essere fuori dalla Comunità Europea: $IP_client" }};
}

$sth->finish;
$dbh->disconnect();
print $cgi->header(-type => "application/json", -charset => "utf-8");
print $json;
