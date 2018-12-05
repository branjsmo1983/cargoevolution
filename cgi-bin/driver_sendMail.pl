#!/usr/bin/perl

use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;
use Fcntl qw(:flock SEEK_END);
use File::Slurp;
use File::Basename;
use utf8;

require "../cgi-bin/sendEmailFunct.pl";

my $dstEmail="giorgiuttim83\@gmail.com";
my $subject="Test mail from MIME";
my $mailBody = "Test message from MIME::lite\n\n";
  
sendEmailFunct($dstEmail, $subject, $mailBody);

$dstEmail="micheleg83\@katamail.com";
sendEmailFunct($dstEmail, $subject, $mailBody);

