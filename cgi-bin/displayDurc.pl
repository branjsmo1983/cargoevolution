#!/usr/bin/perl

use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use CGI::Session;
use DBI;
use DBD::Pg;
use DBD::Pg qw(:pg_types);
use Fcntl qw(:flock SEEK_END);
use File::Slurp;
use File::Basename;
use Digest::MD5;
use Encode;
use strict;

require "../cgi-bin/generatePGTimestamp.pl";
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/operationCompleted.pl";
require "../cgi-bin/escapeTextForPostgres.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/read_file_bin.pl";
require "../cgi-bin/getUidFromEmail.pl";
require "../cgi-bin/getLastDURCFromUserID.pl";

my $q = CGI->new();
my $filename = $q->param('filename');
my $uid = $q->param('uid');

my $result = getLastDURCFromUserID( $uid, $filename );

print $q->header(-type => "text/html", -charset => "utf-8");
print $result;
