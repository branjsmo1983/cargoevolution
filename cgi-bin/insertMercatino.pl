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
   my $name=$q->param('name');
   #my $tel=$q->param('tel');
   #my $form=$q->param('form');
   #my $work=$q->param('work');
   my $email=$q->param('email');
   my $form=$q->param('service');
   my $work=$q->param('type-product');
   my $tel=$q->param('phone');
   my $sid=$q->param('sid');
   my $salary1=$q->param('from-value');
   my $salary2=$q->param('to-value');
   my $salary="Da $salary1 a $salary2";

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
   or die $DBI::errstr;
my $PG_COMMAND=qq{INSERT INTO mercatino( data, message, name, uid, telephone, email, form, work, stipendio)
 VALUES(TIMESTAMP WITH TIME ZONE \'$creation_time\' , ?,?,?,?,?,?,?,?)};

    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

  $sth->execute($message, $name, $company, $tel, $email, $form, $work, $salary)
        or die "Can't execute SQL statement: $dbh::errstr\n";
        my ($response) = $sth->fetchrow_array;

#     # create a JSON string according to the database result
# my $json = qq{{ "success" : "insert message succesful" }};

# # return JSON string
 #print $q->header(-type => "application/json", -charset => "utf-8");
 #print $json;

    $sth->finish;
    $dbh->disconnect();

my $referer = $ENV{HTTP_REFERER};
print $q->redirect(-uri => $referer);


