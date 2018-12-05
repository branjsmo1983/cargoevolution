#!/usr/bin/perl

use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use Path::Class;
use DBI;
use File::Slurp;
use File::Basename;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/sendEmailFunct.pl";
require "../cgi-bin/generateTempHTMLpageForPwdReset.pl";
require "../cgi-bin/generateHTMLCompleteResetPwd.pl";
require "../cgi-bin/insertTransaction.pl";
require "../cgi-bin/getUserIDfromEmail.pl";

print header (-charset => 'UTF-8');
# get data from CGI
my $q = CGI->new();
my $code = $q->param('code');
my $password = $q->param('password');

# retrive the email from the transaction table
my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();
# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
  or die $DBI::errstr;

my $PGSQL_CHECK_EMAIL="select tmp_dat from transactions where message_id=?";
my $sth = $dbh->prepare($PGSQL_CHECK_EMAIL)
        or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute( $code )
      or die "Can't execute SQL statement: $dbh::errstr\n";

my @row = $sth->fetchrow_array;
my $num_res = scalar @row;

if( "$num_res" eq "0" )
{
   # wrong code
   generateHTMLCompleteResetPwd("wrong_code");
}
else
{
  # change the password
  my $email = $row[0];
  my $uid = getUserIDfromEmail($email);
  my $PGSQL_CHANGE_PWD="update users3 set password=? where id=?";
  my $sth = $dbh->prepare($PGSQL_CHANGE_PWD)
        or die "Couldn't prepare statement: " . $dbh->errstr;

  $sth->execute( $password, $uid )
      or die "Can't execute SQL statement: $dbh::errstr\n";

  # remove temporary file the name is in $code
  my $file_to_remove = "/home2/cargoevo/public_html/tmp/$code";
  #print "$file_to_remove";
  unlink $file_to_remove;

  generateHTMLCompleteResetPwd("pwd_changed");

}

