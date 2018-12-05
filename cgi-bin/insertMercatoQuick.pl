#!/usr/bin/perl

use CGI qw(:standard);
use CGI qw(redirect referer);
use CGI::Carp 'fatalsToBrowser';
use CGI;
use DBI;
use strict;
use warnings;
#use DateTime;

require "../cgi-bin/generatePGTimestamp.pl";
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/generatePGTimestamp.pl";

my $q = CGI->new;
my $referer = $ENV{HTTP_REFERER};
print $q->redirect(-uri => $referer);
print header (-charset => 'UTF-8');

my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();
my $creation_time= generatePGTimestamp();



   my $message=$q->param('message');
   my $company=$q->param('company');
   my $email=$q->param('email');
   my $tel=$q->param('phone');
   my $sid=$q->param('sid');
   my $typology=$q->param('typology');

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
   or die $DBI::errstr;
my $PG_COMMAND=qq{INSERT INTO mercato_quick( data, message, company, phone, email,typology)
 VALUES(TIMESTAMP WITH TIME ZONE \'$creation_time\' , ?,?,?,?,?)};

    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

  $sth->execute($message, $company, $tel, $email, $typology)
        or die "Can't execute SQL statement: $dbh::errstr\n";
        my ($response) = $sth->fetchrow_array;


    $sth->finish;
    $dbh->disconnect();

my $referer = $ENV{HTTP_REFERER};
print $q->redirect(-uri => $referer);



