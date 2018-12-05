#!/usr/bin/perl

use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use CGI::Session;
use DBI;
use strict;
use warnings;
use Fcntl qw(:flock SEEK_END);

require "../cgi-bin/generateChatTableScript.pl";
require "../cgi-bin/generateChatTableScriptMulti.pl";

print header (-charset => 'UTF-8');

my $q = CGI->new();
my $multi = $q->param('multi');
# ContactMessageID
my $mid = $q->param('ContactMessageID');
my $sid = $q->param('sid');


if( $multi eq "True" )
{
  my $num_user_to_contact = $q->param('chatCombo'); # or chat_index
  generateChatTableScriptMulti($mid, $sid, $num_user_to_contact);
}
else
{
  generateChatTableScript($mid, $sid);
}
