#!/usr/bin/perl

use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use Path::Class;

require "../cgi-bin/generateHTMLopenTag.pl";
require "../cgi-bin/generateHTMLheader.pl";
require "../cgi-bin/generateHTMLFooter.pl";

my $q = CGI->new();
my $sid = $q->param('sid');

print header (-charset => 'UTF-8');
print "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 5.0 Final//IT\" >\n";
generateHTMLopenTag();
generateHTMLheader("Work in progress","");
print"<body>\n";
print "<header>Pagina in fase di sviluppo</header>";
print "<center>\n";
print "<p>\n";
print "Work in progress\n";
print "</p>\n";
print "<p>\n";
print "<p>\n<a href=\"generateHTMLHome.pl?sid=$sid\">Clicca qui per tornare Indietro</a>\n</p>\n";
print "</p>\n";
print "</center>\n";
generateHTMLFooter();
print"</body>\n<html>\n";

