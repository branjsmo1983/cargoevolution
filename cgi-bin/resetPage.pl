#!/usr/bin/perl

use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use Path::Class;

require "../cgi-bin/generateHTMLopenTag.pl";
require "../cgi-bin/generateHTMLheader.pl";
require "../cgi-bin/generateHTMLFooter.pl";

print header (-charset => 'UTF-8');
print "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 5.0 Final//IT\" >\n";
generateHTMLopenTag();
generateHTMLheader("Reset password","");
print"<body>\n";
print "<header><h1>Reset password</h1></header>";
print "<center>\n";
print <<EOF;
<p>Inserisci il tuo indirizzo email, e premi OK.</p>
<p>Una mail contenente il link per il reset ti verrà spedita al più presto.</p>
EOF

# create temporary session to avoid double insertions
my $session = new CGI::Session("driver:File", undef, {Directory=>"/tmp"});
my $sid = $session->id();
# create the tokens
my $new_token= rand(10000000);
# save the token  into the user session
$session->param("token", "$new_token");
$session->param("token_face1", "$new_token");

$session->flush();
$session->close();

# form to contain the button
print "<form action=\"/cgi-bin/sendEmailResetPwd.pl\" method=\"post\" enctype=\"multipart/form-data\">\n";
print "<p>\n";
print "E-mail: <input type=\"email\" required=\"required\" id=\"uemail\" name=\"uemail\" size=\"18\" ></input>\n";
print "</p>\n";
print "<p><input type=\"hidden\" id=\"sid\" name=\"sid\" value=\"$sid\" /></p>\n";
print "<button type=\"submit\" class=\"button positive\">\n";
print "<img />OK</button>"; 
print "</form>";

print "</center>\n";
generateHTMLFooter();
print"</body>\n<html>\n";
