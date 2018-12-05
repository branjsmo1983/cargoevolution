#!/usr/bin/perl

use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use CGI::Session;
use DBI;
use strict;
use warnings;
use Fcntl qw(:flock SEEK_END);

require "../cgi-bin/generateContactUserForm.pl";
require "../cgi-bin/generateErrorPage.pl";
require "../cgi-bin/getEmailFromUserID.pl";
require "../cgi-bin/get_temp_filename.pl";
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/validateUserID.pl";

my $q = CGI->new();
# ContactMessageID
my $messageID = $q->param('WriteMessageID');
my $sid = $q->param('sid');

my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $buyer = $session->param("buyer");
my $ID = $session->param("username");

validateUserID($ID, $sid);
# TODO: create also a database for the Notes sent between the users relative to messages.
if( $buyer eq "True" )
{
   
}
else
{

}

