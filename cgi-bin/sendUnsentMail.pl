#!/usr/bin/perl -CD

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
use Try::Tiny;
use utf8;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/sendEmailFunct.pl";

my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

# Empty the unsent_mail queue first
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
   or die $DBI::errstr;

my $PG_COMMAND = "SELECT mail_to, subject, body, status, id from unsent_mail where status = '0' ORDER BY RANDOM()";

my $sth = $dbh->prepare($PG_COMMAND)
  or die "Couldn't prepare statement: " . $dbh->errstr;
$sth->execute(  )
  or die "Can't execute SQL statement: " . $dbh->errstr;
print "AAAA\n";
my $cnt = 0;

while (my @row = $sth->fetchrow_array and $cnt < 31 ) {
    my $dstEmail = $row[0];
    my $subject = $row[1];
    my $body = $row[2];
    my $status = $row[3];
    my $eid = $row[4];
    # utf8::encode($body);
    $body = substr($body, 3, -4); 

    try {
      # sendEmailFunct( $dstEmail, $subject,  $body );
	sendEmailSendinBlue($dstEmail, $subject, $body );
      # mark message as sent
      my $sth2 = $dbh->prepare("UPDATE  unsent_mail SET status = ? where id = ?");
      $sth2->execute( 1, $eid )
        or die "Can't execute SQL statement: " . $dbh->errstr;
      $sth2->finish;
      sleep( 2 );
    } catch{
      print "Cannot send email to $dstEmail\n";
    };
    $cnt = $cnt + 1;
    print "$cnt $dstEmail\n";
    print $body . "\n<<<<<<<<<<<<<<<<<<<<<<\n";
    # print "\n$body================\n"
}

$sth->finish;
$dbh->disconnect();
