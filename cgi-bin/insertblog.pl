#!/usr/bin/perl

use CGI qw(:standard);
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



	print header (-charset => 'UTF-8');

my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();
my $creation_time= generatePGTimestamp();

my $q = CGI->new;

   my $message=$q->param('message');
   my $user=$q->param('user');
   my $company=$q->param('company');
    # my $dt   = DateTime->now;   # Stores current date and time as datetime object
    # my $date = $dt->ymd;
    # create time stamp
    #my $creation_time = generatePGTimestamp();
# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
   or die $DBI::errstr;
    my $PG_COMMAND=qq{INSERT INTO blog(message, date, uid )
 VALUES(?,  TIMESTAMP WITH TIME ZONE \'$creation_time\-07\' , ?)};

    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute(  $message, $company )
        or die "Can't execute SQL statement: $dbh::errstr\n";
        my ($response) = $sth->fetchrow_array;

#     # create a JSON string according to the database result
# my $json = qq{{ "success" : "insert message succesful" }};

# # return JSON string
# print $q->header(-type => "application/json", -charset => "utf-8");
# print $json;

    $sth->finish;
    $dbh->disconnect();
