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
my $sid = $cgi->param('sid');
my $CompanyName = $cgi->param('CompanyName');
my $TableIndex = $cgi->param('TableIndex');

my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $uid = $session->param("username");

my $PG_COMMAND=qq{INSERT INTO blacklist (uid, uid2block) SELECT '$uid', id from users3 where company_name = '$CompanyName'};
    
my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();
    
# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
   or die $DBI::errstr;
  
my $sth = $dbh->prepare($PG_COMMAND)
   or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute( )
   or die "Can't execute SQL statement: $dbh::errstr\n";

my $json = qq{{"success" : "insertion was successfull", "TableIndex" : "$TableIndex"}};

print $cgi->header(-type => "application/json", -charset => "utf-8");
print $json;

