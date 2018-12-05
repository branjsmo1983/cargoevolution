#!/usr/bin/perl

use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use CGI::Session;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/generatePGTimestamp.pl";
require "../cgi-bin/operationCompleted.pl";
require "../cgi-bin/generateChatForm.pl";
require "../cgi-bin/getUidFromMessageID.pl";
require "../cgi-bin/getUidsForChat.pl";
require "../cgi-bin/getEmailFromUserID.pl";
require "../cgi-bin/getTripInformationFromMID.pl";
require "../cgi-bin/sendEmailFunct.pl";
require "../cgi-bin/getEmailAndSkypeFromUserID.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/firstMessage.pl";
require "../cgi-bin/getRegionIT.pl";


my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
   or die $DBI::errstr;

# get variables from user session
my $q = CGI->new();
my $sid = $q->param('sid');
my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $my_id= $session->param("username");

my $PGSQL_QUERY= "select region from regions where uid =? ORDER BY region";

my $sth = $dbh->prepare($PGSQL_QUERY)
   or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute( $my_id )
    or die "Can't execute SQL statement: $dbh::errstr\n";

# my $json = qq{{"success" : "Yo!!"}};
my $json="{";
# prepare output json
my @row;
my $cnt=0;
while (@row = $sth->fetchrow_array)
{
   $json =  $json . qq{"region$cnt" : \"$row[0]\",};
   $cnt++;
}
my $json2 = chop( $json );
$json =  $json . "}";


$sth->finish;
$dbh->disconnect();

print $q->header(-type => "application/json", -charset => "utf-8");
print $json;
