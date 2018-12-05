#!/usr/bin/perl

use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use Path::Class;
use DBI;
use DBD::Pg;
use DBD::Pg qw(:pg_types);
use strict;
use warnings;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
require "../cgi-bin/generateHTMLheader.pl";
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/validateUserID.pl";
require "../cgi-bin/getAdminHash.pl";

print header (-charset => 'UTF-8');

my $q = CGI->new();
my $sid = $q->param('sid');

my $usession = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $uid = $usession->param('username');
my $user_valid = validateUserID($uid, $sid  );

if( $user_valid eq "False" )
{
  exit;
}

if ( getAdminHash() eq $uid or "2cff49e7376ab1b303b40e5e66c3795a" eq  $uid or "23f83ef1ed40e8cf5e7184591640e4aa" eq $uid )
{

}
else
{
  print "Forbidden!";
  exit;
}

my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
   or die $DBI::errstr;

my $PG_COMMAND="select html_link, uid, username, users3.email from account_events right outer join users3 ON(users3.id = account_events.uid)  order by email DESC";
my $sth = $dbh->prepare($PG_COMMAND)
    or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute()
    or die "Couldn't execute statement: " . $dbh->errstr;

generateHTMLheader("List of account Events");
my $cnt = 1;

my @row;
while(@row = $sth->fetchrow_array){
	my $username = $row[2];
  my $email = $row[3];
  my $company_name = $row[2];
  my $link = $row[0];

  print "<p>$cnt) username = $username, E-mail = $email, link = $link </hr></p>\n";
  $cnt = $cnt + 1;
}

$sth->finish;
$dbh->disconnect();
