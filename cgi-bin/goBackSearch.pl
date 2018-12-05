#!/usr/bin/perl

use strict;
use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use Path::Class;
use DBI;

require "../cgi-bin/generateHTMLResultTable.pl";
require "../cgi-bin/postDBIexecute.pl";
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

my $q = CGI->new();

my $sid = $q->param('sid');
my $page_num = $q->param('page_num');
my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});

my $PG_COMMAND = $session->param("pgcommand");
my $options = $session->param("pgoptions");

my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
  or die $DBI::errstr;

print $q->header("text/html");
# print "\$sid = $sid\n";
# print "\$PG_COMMAND = $PG_COMMAND\n";
# print "\$options = $options\n";

my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

postDBIexecute( $sth, $options );
generateHTMLResultTable( $sth, $sid, "pageLink", $page_num );

$sth->finish;
$dbh->disconnect();

