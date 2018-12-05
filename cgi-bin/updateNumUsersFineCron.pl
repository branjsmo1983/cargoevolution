#!/usr/bin/perl

use lib ('../public_html/cgi-bin');
use strict;
use Fcntl qw(:flock SEEK_END);
use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "getNumUsersOnline.pl";

my $num_users = getNumUsersOnline();
my $PG_COMMAND=qq{update num_users set num=? };

my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
   or die $DBI::errstr;


my $sth = $dbh->prepare($PG_COMMAND)
  or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute( $num_users )
  or die "Couldn't execute statement: " . $dbh->errstr;


print "\$num_users = $num_users\n";
