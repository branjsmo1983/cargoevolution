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
require "../cgi-bin/getMessageStatus.pl";
require "../cgi-bin/setMessageStatus.pl";
require "../cgi-bin/updateBuyerID.pl";
require "../cgi-bin/sendEmailFunct.pl";
require "../cgi-bin/getEmailFromUserID.pl";
require "../cgi-bin/getTripInformationFromMID.pl";
require "../cgi-bin/getPhoneNumbers.pl";

require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

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
my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});

my $mid = $session->param("mid");
my $uid= $session->param("uid");

# get chat index if necassary
my $did;
my $chat_index;
$chat_index = $q->param("chat_index");
my @uids = getUidsForChat( $mid, $sid );
$did = $uids[$chat_index]; # id of the winner

my $status = getMessageStatus( $mid );

if(  "$status" eq "0" )
{
   setMessageStatus( $mid, 1 );
   updateBuyerID( $did, $mid );
}
else
{
   # the message has already been assigned
}

# send email to end user before returning
my $email_my = getEmailFromUserID( $uid );
my $email_did = getEmailFromUserID( $did );

my $phone_my = getPhoneNumbers( $uid );
$phone_my =~ s/!/, /g; 
my $phone_did = getPhoneNumbers( $did );
$phone_did =~ s/!/, /g; 

# send mail to the winner
my $subject="Cargoevolution trasporto concordato";
my $srcEmail=$email_my;
my $dstEmail=$email_did;

      my $trip_info_with_no_link = getTripInformationFromMID( $mid );
      $trip_info_with_no_link = "$trip_info_with_no_link\n\n\n";
      my $mailBody = "$srcEmail tel. $phone_my è il tuo contatto\n\n--------------------------------------------------------\n$trip_info_with_no_link\n\n";
      $mailBody = "$mailBody--------------------------------------------------------\n\n";
      $mailBody = "$mailBody Messaggio automatizzato di cargoevolution.com,\n si prega di non rispondere a questo\nindirizzo mail;\n";

sendEmailFunct($dstEmail, $subject, $mailBody, $srcEmail);

my $mailBody2 = "$dstEmail tel. $phone_did è il tuo contatto\n\n--------------------------------------------------------\n$trip_info_with_no_link\n\n";
      $mailBody2 = "$mailBody2--------------------------------------------------------\n\n";
      $mailBody2 = "$mailBody2 Messaggio automatizzato di cargoevolution.com,\n si prega di non rispondere a questo\nindirizzo mail;\n";

# send email to the insertionist
sendEmailFunct($srcEmail, $subject, $mailBody2, $dstEmail);

my $message="Completed Action";
generateChatForm( $sid, $mid, $uid,  $message, $did, $chat_index );



