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
require "../cgi-bin/getEmailFromMID.pl";
require "../cgi-bin/sendEmailFunct.pl";
require "../cgi-bin/getTripInformationFromMID.pl";
require "../cgi-bin/eraseTransaction.pl";

my $q = CGI->new();
my $messageID = $q->param('messageID');

my $sid = $q->param('sid');
# get user ID from user session
my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $ID = $session->param("username");

# use the token to avoid double messaging
my $token = $session->param("token");
my $token_face1 = $session->param("token_face1");

if( $token ne $token_face1 )
{
    operationCompleted($sid, "Messaggio di rifiuto già spedito");
}
else
{
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

    my $cont_email = getEmailFromMID( $messageID );
    my $subject;
    my $mailBody;

    # at this point reset the buyerID
    updateBuyerID("0", $messageID);
    # send an email that the proposal has been refuted
    my $subject="Cargoevolution, richiesta rifiutata";
    my $mailBody = getTripInformationFromMID( $messageID );

    $mailBody = "www.cargoevolution.com/login.html\n$mailBody";

    sendEmailFunct( $cont_email, $subject, $mailBody );
    # TODO erease transaction files
    my $transactionID = eraseTransaction( $messageID );

    my $new_token= rand(10000000);
    $session->param("token_face1", "$new_token");
    operationCompleted($sid, "Messaggio di rifiuto spedito");
}

