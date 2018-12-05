#!/usr/bin/perl -T

use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";


my $cgi = CGI->new;
my $username = $cgi->param("email");
$username =~ s/^\s+|\s+$//g;
my $PG_COMMAND=qq{SELECT email FROM users3 WHERE email=?};

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

my $username_fromDB = $sth->fetchrow_array;

# prepare JSON reply
my $json = ($username_fromDB) ?
   qq{{"error" : "email già registrata", "email" : "$username"}} :
   qq{{"success" : "email available"}};

$sth->finish;
$dbh->disconnect();
print $cgi->header(-type => "application/json", -charset => "utf-8");
print $json;
