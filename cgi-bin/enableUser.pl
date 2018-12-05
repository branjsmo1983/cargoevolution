#!/usr/bin/perl
use cPanelUserConfig;
use CGI;
use CGI::Session;
use DBI;
use strict;
use warnings;

use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/generateHTMLCompleteRegistration.pl";

print header (-charset => 'UTF-8');
my $cgi = CGI->new;

# get session ID from CGI
my $sid= $cgi->param("sid");
my $code = $cgi->param('code');
#get username from User session
my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $username = $session->param("username");

my $PG_COMMAND=qq{UPDATE users3 SET enabled='1' WHERE id=?};

my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
   or die $DBI::errstr;

my $sth = $dbh->prepare($PG_COMMAND)
   or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute( $username )
      or die "Can't execute SQL statement: $dbh::errstr\n";

$sth->finish;
$dbh->disconnect();

my $file_to_remove = "/home2/cargoevo/public_html/tmp/$code";
#print "$file_to_remove";
unlink $file_to_remove;

generateHTMLCompleteRegistration("activation_completed");
