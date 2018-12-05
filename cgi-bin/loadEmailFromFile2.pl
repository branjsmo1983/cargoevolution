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

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/getDatabasePwd.pl";

my $filename = 'last.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

# connect to database
my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
    or die $DBI::errstr;


while (my $row = <$fh>) {
  chomp $row;
  print "Loading $row\n";
  my $PG_COMMAND="insert into sent_mail( email ) values(E\'$row\')   RETURNING id";

  my $sth = $dbh->prepare($PG_COMMAND)
         or die "Couldn't prepare statement: " . $dbh->errstr;

  $sth->execute( );

}
