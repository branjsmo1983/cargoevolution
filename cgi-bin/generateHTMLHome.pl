#!/usr/bin/perl
# Display dynamic contents on a web page
# run the C++ program to generate the HTML text file
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
print header (-charset => 'UTF-8');
use Path::Class;

require "../cgi-bin/generateHTMLActionPage.pl";

my $q = CGI->new();
my $sid = $q->param('sid');

generateHTMLopenTag();
generateHTMLheader("Operation completed");
generateHTMLActionPage( "view", $sid, "from_redirection" );
