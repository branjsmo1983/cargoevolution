#!/usr/bin/perl
# Display dynamic contents on a web page
# run the C++ program to generate the HTML text file
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
use Path::Class;
use DBI;

require "../cgi-bin/italia.pl";
require "../cgi-bin/generateHTMLSelectorRegionIT.pl";
require "../cgi-bin/generateHTMLSelectorProvinceIT.pl";
require "../cgi-bin/generateHTMLInputForm.pl";
require "../cgi-bin/generateHTMLRedirectionButtons.pl";
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/operationCompleted.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/eraseTransaction.pl";
require "../cgi-bin/getLinkToLoginPage.pl";

#print header;

my $q = CGI->new();
my $MsgID = $q->param('MsgID');
my $sid = $q->param('sid');

my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
  or die $DBI::errstr;
  
#retrieve the ID, email of the User who wrote the message from the database
my $messages_table_name="messages2";
my $PG_COMMAND=qq{update $messages_table_name SET status =1  where id=?};

my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute( $MsgID )
    or die "Can't execute SQL statement: $dbh::errstr\n";
$sth->finish;

# TODO: check the status

# redirect to the I/O pages
# STUB: the user ID can be reteived by the use of "messages table", without sending the ID to the email.
# retrieve the useID to ridirect to the initial page with requiring the login
$PG_COMMAND=qq{select username from $messages_table_name where id=?};
$sth = $dbh->prepare($PG_COMMAND);

$sth->execute( $MsgID )
    or die "Can't execute SQL statement: $dbh::errstr\n";

my $username;
my @row2 = $sth->fetchrow_array;

if( (scalar @row2) != 0 )
{
   # username found
   $username = $row2[0];
}
else
{
   $username = 0;
}

$sth->finish;
$dbh->disconnect();

# erease temporary files
my $transactionID = eraseTransaction( $MsgID );

# print status and to close tha page without redirecting to the login (just for security).
# operationCompleted( $sid, "Messaggio processato\n");
# redirect to homepage
# CGI::redirect("http://cargoevolution.com/login.html");
print header (-charset => 'UTF-8');
# my $url = "http://www.cargoevolution.com/login.html";
my $url = getLinkToLoginPage();
#print "Content-type: text/html\n\n"; 

print qq[
      <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
      <html>
      <head>
      <title>Redirecting...</title>
      <meta HTTP-EQUIV="REFRESH" CONTENT="10;URL=$url">
      </head>
      <body>
      </body>
      </html>
     ];

