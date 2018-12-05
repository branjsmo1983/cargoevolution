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

print header (-charset => 'UTF-8');

my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
   or die $DBI::errstr;

# get variables from user session
my $q = CGI->new();
my $sid = $q->param('sid');
my $region_num = $q->param('region');
my $region = getRegionIT( $region_num );
my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $my_id= $session->param("username");

my $PGSQL_QUERY= "select uid from regions where uid=? and region=?";

my $sth = $dbh->prepare($PGSQL_QUERY)
   or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute( $my_id, $region )
    or die "Can't execute SQL statement: $dbh::errstr\n";

my $write_db;
my @row = $sth->fetchrow;

if( scalar( @row ) == 0 )
{
  $write_db = "True";
}
else
{
  $write_db = "False";
}

$sth->finish;

if( $write_db eq "True"  )
{
  # write data to dB if necessary
  $PGSQL_QUERY= "insert into regions(uid, region) values(?, ?)";
  $sth = $dbh->prepare($PGSQL_QUERY)
     or die "Couldn't prepare statement: " . $dbh->errstr;

  $sth->execute( $my_id, $region )
      or die "Can't execute SQL statement: $dbh::errstr\n";

  $sth->finish;
}
else
{
  # erease entry from  dB
  $PGSQL_QUERY= "delete from regions where uid=? and region=?";
  $sth = $dbh->prepare($PGSQL_QUERY)
     or die "Couldn't prepare statement: " . $dbh->errstr;

  $sth->execute( $my_id, $region )
      or die "Can't execute SQL statement: $dbh::errstr\n";

  $sth->finish;
}

# update the status of the regions compiled as well
$PGSQL_QUERY= "update users3 set regions_comp = ? where id = ?";
$sth = $dbh->prepare($PGSQL_QUERY)
   or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute( 1 ,$my_id )
    or die "Can't execute SQL statement: $dbh::errstr\n";

$sth->finish;

$dbh->disconnect();
