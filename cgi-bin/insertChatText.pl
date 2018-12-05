#!/usr/bin/perl

use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use CGI::Session;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/generatePGTimestamp.pl";
require "../cgi-bin/operationCompleted.pl";
require "../cgi-bin/generateChatForm.pl";
require "../cgi-bin/getUidFromMessageID.pl";
require "../cgi-bin/getUidsForChat.pl";
require "../cgi-bin/getEmailFromUserID.pl";
require "../cgi-bin/getTripInformationFromMID.pl";
require "../cgi-bin/sendEmailFunct.pl";
require "../cgi-bin/getEmailAndSkypeFromUserID.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/firstMessage.pl";

print header (-charset => 'UTF-8');

my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
   or die $DBI::errstr;

# get variables from user session
my $q = CGI->new();
my $sid = $q->param('sid');
my $ctext = $q->param('ctext');
my $multi = $q->param('multi');
my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});

my $mid = $session->param("mid");
my $uid= $session->param("uid");

# get chat index if necassary
my $did;
my $chat_index;
if( $multi )
{
   $chat_index = $q->param("chat_index");
   my @uids = getUidsForChat( $mid, $sid );
   $did = $uids[$chat_index];
}
else
{
   $did = getUidFromMessageID($mid);
   # print "\$did = $did\n";
   #return;
}


my $creation_time= generatePGTimestamp();
# get token from user session
my $token = $session->param("token");
my $token_face1 = $session->param('token_face1');
my $token_valid="True";

$ctext = $dbh->quote( $ctext );

my $PGSQL_INSERT="INSERT into chats(\"mid\", \"uid\", \"text\", \"creation_time\", \"did\") values(\'$mid\', \'$uid\', $ctext, TIMESTAMP WITH TIME ZONE \'$creation_time\-07\', \'$did\')";

my $message;
my $sth;

if( $token_valid eq "True" )
{
   $message = "Messaggio spedio";
   my $new_token= rand(10000000);
   my $firstMessage = firstMessage($mid, $did, $uid);
   # save the token  into the user session
   $session->param("token", "$new_token");

   $sth = $dbh->prepare($PGSQL_INSERT)
      or die "Couldn't prepare statement: " . $dbh->errstr;

   $sth->execute( )
       or die "Can't execute SQL statement: $dbh::errstr\n";

   $sth->finish;
   # send email to the user as asynchronous communication
   my @row = getEmailAndSkypeFromUserID( $did );
   my $email_did = $row[0];
   my $skype_dst = $row[1];
   my $subject="Un utente è interessato ad un tuo viaggio presente sul circuito";
   my $srcEmail="info\@cargoevolution.com";
   my $dstEmail=$email_did;

   my $trip_info_with_no_link = getTripInformationFromMID( $mid );
   my $mailBody="Accedi a www.cargoevolution.com/login.html\n\nDettagli trasporto: \n--------------------------------------------------------\n$trip_info_with_no_link\n\n--------------------------------------------------------\n\n";
$mailBody = "$mailBody Messaggio automatizzato di cargoevolution.com,\n si prega di non rispondere a questo\nindirizzo mail;\n";

   if( $firstMessage eq "True" )
   {
	sendEmailFunct($dstEmail, $subject, $mailBody, $srcEmail,$skype_dst);
   }
   else
   {
	#print "<p>Not the first message</p>\n";
   }
}
else
{
   $message = "Messaggio già spedio";
}

#if( $multi )
#{
#   generateChatForm( $sid, $mid, $uid,  $message, $did);
#}
#else
#{
#   generateChatForm( $sid, $mid, $uid,  $message, $did, $chat_index );
#}


$dbh->disconnect();
