#!/usr/bin/perl

use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use CGI::Session;
use strict;
use warnings;

require "../cgi-bin/validateUserID.pl";
require "../cgi-bin/validateMessageOwnership.pl";
require "../cgi-bin/updateBuyerID.pl";
require "../cgi-bin/operationCompleted.pl";
require "../cgi-bin/deleteMessage.pl";
require "../cgi-bin/selectUserMessagesFunct.pl";
require "../cgi-bin/deleteZombieEmails.pl";

my $q = CGI->new();
my $messageID = $q->param('messageID');
my $sid = $q->param('sid');
my $type = $q->param('type');
# get user ID from user session
my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $ID = $session->param("username");

# validate the user
my $userValid= validateUserID( $ID, $sid);

if( $userValid eq "False" )
{
    exit;
}

# check the corrispondance of user ID and message ID
my $correlationOK = validateMessageOwnership($ID, $messageID);

if( $correlationOK eq "False" )
{
    exit;
}

# at this point reset the buyerID
deleteMessage($messageID, $type);
deleteZombieEmails( $messageID );

selectUserMessagesFunct( $sid );
# operationCompleted($sid, "Messaggio sbloccato");
