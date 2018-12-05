#!/usr/bin/perl
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
use Path::Class;
use DBI;
use strict;

require "getDatabasePwd.pl";
require "getDatabaseUsername.pl";
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/generatePGTimestamp.pl";

my $q = CGI->new();

my $my_uid = $q->param('my_uid');
my $mid = $q->param('mid');
my $curr_feed = $q->param('curr_feed');
my $feedback_comment = $q->param('feedBackComment');



my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

my $timestamp = generatePGTimestamp();

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
   or die $DBI::errstr;

my $feedback= $dbh->quote($feedback_comment);

# find the uid of the other user
my $PGSQL_SELECT_ID = "SELECT id FROM users3 where (id IN (SELECT username FROM messages2 where id=?) or id IN (SELECT buyerid FROM messages2 where id=?)) and id <> ?";
my $sth = $dbh->prepare($PGSQL_SELECT_ID)
     or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute( $mid, $mid, $my_uid)
     or die "Can't execute SQL statement: $dbh::errstr\n";

my @row = $sth->fetchrow_array;
my $other_id = $row[0];

my $PGSQL_INSERT="INSERT into feedback(\"userid_from\", \"message_id\", \"score\", \"creation_time\", \"userid_of\", \"notes\") values(\'$my_uid\', \'$mid\', \'$curr_feed\', TIMESTAMP WITH TIME ZONE \'$timestamp\-07\', ?, $feedback)";

$sth = $dbh->prepare($PGSQL_INSERT)
     or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute( $other_id )
     or die "Can't execute SQL statement: $dbh::errstr\n";

$sth->finish;

print header (-charset => 'UTF-8');
print "<p>Grazie, hai lasciato il feedback in modo corretto</p>";
