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

print header (-charset => 'UTF-8');
# get data from CGI
my $q = CGI->new();
my $uemail = $q->param('uemail');

# check that the email exists and warn the user otherwise
my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
  or die $DBI::errstr;

my $PGSQL_CHECK_EMAIL="select id, username from users3 where email=?";
my $sth = $dbh->prepare($PGSQL_CHECK_EMAIL)
        or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute( $uemail )
      or die "Can't execute SQL statement: $dbh::errstr\n";

my @row = $sth->fetchrow_array;
my $num_res = scalar @row;

if( "$num_res" eq "0" )
{
    # email address not found in database
    generateHTMLCompleteResetPwd("not_found");
}
else
{
   my $username=$row[1];
   my $sid = $q->param('sid');
   my $usession = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
   # get token from session
   my $token = $usession->param("token");
   my $token_face1 = $usession->param("token_face1");

   if( $token_face1 eq $token)
   {
      # mark token
      my $new_token= rand(10000000);
      # save the token  into the user session
      $usession->param("token_face1", "$new_token");
      # generate temporary page
      my $page_path = generateTempHTMLpageForPwdReset();
      my ($name, $path, $suffix) = fileparse($page_path);
      insertTransaction($name, $page_path, $uemail );

      my $link = "www.cargoevolution.com/tmp/$name";
      my $subject = "Cargoevolution, reset password";
      my $srcEmail = "info\@cargoevolution.com";
      my $mailBody = "Ciao $username,\n clicca il seguente link per accedere alla pagina di reset:\n\n$link\n\n\nSe non sei stato tu a richiedere il cambio della password contatta immediatamente info\@cargoevolution.com\n\n";
   $mailBody="$mailBody\nIl link è valido per 24 ore, poi verrà automaticamente cancellato\n\nRicordati che lo username per accedere è \"$username\"";
      # send the email
      sendEmailFunct( $uemail, $subject, $mailBody);
      generateHTMLCompleteResetPwd();
   }
   else
   {
      # email already sent
      generateHTMLCompleteResetPwd("double_insertion");
   }
   $usession->flush();
   $usession->close();
}


$sth->finish;
$dbh->disconnect();
