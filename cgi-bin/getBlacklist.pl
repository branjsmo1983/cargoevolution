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

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";


my $cgi = CGI->new;
my $sid = $cgi->param('sid');

my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $uid = $session->param("username");

my $PG_COMMAND=qq{select company_name from users3 where id IN (select uid2block from blacklist where uid=?)};
    
my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();
    
# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
   or die $DBI::errstr;
  
my $sth = $dbh->prepare($PG_COMMAND)
   or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute( $uid )
   or die "Can't execute SQL statement: $dbh::errstr\n";

my @row;
   my @results;
   while (@row = $sth->fetchrow_array) {
       push @results, $row[0];
    }
    
$sth->finish;
$dbh->disconnect();

my $scalar_result = join('|', @results);
my $json;

if( scalar(@results) != 0 )
{
   $json = qq{{"success" : "$scalar_result"}};
}
else
{
   $json = qq{{"success" : ""}};
}


print $cgi->header(-type => "application/json", -charset => "utf-8");
print $json;

