#!/usr/bin/perl
# Display dynamic contents on a web page
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
use Path::Class;
use DBI;
use strict;
use warnings;

require "../cgi-bin/generateHTMLRedirectionButtons.pl";
require "../cgi-bin/generateHTMLheader.pl";
require "../cgi-bin/generateHTMLopenTag.pl";
require "../cgi-bin/generateHTMLInputForm.pl";
require "../cgi-bin/generateHTMLActionPage.pl";
require "../cgi-bin/getFeedbackFromUserID.pl";
require "../cgi-bin/updateTimeLastAction.pl";

my $q = CGI->new();
my $sid = $q->param('sid');
my $from_link = $q->param('fromLink');

print header (-charset => 'UTF-8');

my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $uid = $session->param("username");
my $feed_back = getFeedbackFromUserID( $uid );
updateTimeLastAction( $uid );
$session->param("my_feedback_stat", "$feed_back");

if( $from_link )
{
   generateHTMLopenTag();
   generateHTMLheader();
}

generateHTMLActionPage( "view", $sid, "from_login" );
