#!/usr/bin/perl

use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use CGI::Session;
use DBI;
use strict;
use warnings;

my $q = CGI->new();

my $sid = $q->param('sid');
my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
$session->delete();

# redirect to the home page
print $q->redirect('/index.html');
