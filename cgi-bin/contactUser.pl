#!/usr/bin/perl

use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use CGI::Session;
use DBI;
use strict;
use warnings;
use Fcntl qw(:flock SEEK_END);

#require "../cgi-bin/generateContactUserForm.pl";
require "../cgi-bin/generateChatForm.pl";
require "../cgi-bin/generateErrorPage.pl";
require "../cgi-bin/getEmailFromUserID.pl";
require "../cgi-bin/get_temp_filename.pl";
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getUidFromMessageID.pl";
require "../cgi-bin/updateTimeLastAction.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/validateUserID.pl";

print header (-charset => 'UTF-8');
my $q = CGI->new();
# ContactMessageID
my $messageID = $q->param('ContactMessageID');
my $sid = $q->param('sid');
my $page_num = $q->param('page_num');
# get user ID from user session
my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $MyID = $session->param("username");
my $mail_only = $q->param('mail_only');
my $from_quick_links = $q->param('fromQuickLinks');

# refresh time stamp of last action
updateTimeLastAction( $MyID );

# save message ID into session
$session->param("uid", $MyID);
$session->param("mid", $messageID);
$session->param("page_num", $page_num);

if( $from_quick_links )
{
   $session->param("fromQuickLinks", 1);
}
else
{
   $session->param("fromQuickLinks", 0);
}


validateUserID($MyID, $sid);

my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
  or die $DBI::errstr;

#retrieve the ID, email of the User who wrote the message from the database
my $messages_table_name="messages2";
my $PG_COMMAND=qq{SELECT * FROM $messages_table_name WHERE id=?};

my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute( $messageID );

my @row = $sth->fetchrow_array;
my $notes = $row[12];

my $fileContents = join( "#", @row );

my $num_el = scalar @row;

if( $num_el != 0 )
{
    # Reteive the emial of the user and generate the input form for the user
    my $userID_who_wrote_the_message = $row[1];
    my $email_dest = getEmailFromUserID( $userID_who_wrote_the_message );
    my $email_src = getEmailFromUserID( $MyID );

    if( $email_dest and $email_src )
    {
        my $message="yo1";
	my $did = getUidFromMessageID( $messageID );
        $session->flush();
        $session->close();
        generateChatForm( $sid, $messageID, $MyID, $message, $did );

    }
    else
    {
        # email not found, cannot contact the User
        generateErrorPage("User not found in database");
    }
}
else
{
    # Message ID not found generate error page, this should not happen
    generateErrorPage("Message not found! (A database merge gone wrong?)");
}

$sth->finish;
$dbh->disconnect();
