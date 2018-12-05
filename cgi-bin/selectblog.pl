#!/usr/bin/perl -T
use CGI;
use DBI;
use strict;
use warnings;
 
# read the CGI params
my $cgi = CGI->new;
my $username = $cgi->param("username");
my $password = $cgi->param("password");
 
# connect to the database
my $dbh = DBI->connect("DBI:mysql:database=;host=;port=",  
  "", "") 
  or die $DBI::errstr;
 
# check the username and password in the database
my $statement = qq{SELECT id FROM users WHERE username=? and password=?};
my $sth = $dbh->prepare($statement)
  or die $dbh->errstr;
$sth->execute($username, $password)
  or die $sth->errstr;
my ($userID) = $sth->fetchrow_array;
 
# create a JSON string according to the database result
my $json = ($userID) ? 
  qq{{"success" : "login is successful", "userid" : "$userID"}} : 
  qq{{"error" : "username or password is wrong"}};
 
# return JSON string
print $cgi->header(-type => "application/json", -charset => "utf-8");
print $json;

    my $database_name=getDatabaseName();
   my $db_username=getDatabaseUsername();
   my $db_pwd=getDatabasePwd();
                   # connect to the database
   my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;
  
   my $PG_COMMAND="select message,date from blog order by date DESC";
   my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

   $sth->execute()
       or die "Can't execute SQL statement: $dbh::errstr\n";
   
  
  
   
   my @row;
  print " <div class=\"container\"> ";
    print " <h2>Lista dei messaggi</h2> ";
   while (@row = $sth->fetchrow_array) {
  print "<ul class=\"list-group\"> ";
   print "<li class = \"list-group-item  list-group-item-success \"> info :  $row[0]</li>
   <li class = \"list-group-item  list-group-item-warning \"> in data : $row[1]</li>";
 
print "</ul>";
   }
