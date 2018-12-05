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
generateHTMLheader("Presentazione CARGOEVOLUTION","");
print"<body>\n";
print "<header><h1>Presentazione Cargoevolution</h1></header>";
print "<article>\n";
print "<center>\n";
print "<p>\n<a href=\"generateHTMLHome.pl?sid=$sid\">Clicca qui per tornare Indietro</a>\n</p>\n";
print "</center>\n";
print <<EOF;

<p>Cos'è CARGOEVOLUTION
<p>
Questo progetto nasce da un'idea di Fabrizio Cecutti (con esperienza decennale nel settore trasporti in varie aziende del Friuli Venezia Giulia) e dalle competenze informatiche di Michele Giorgiutti (ingegnere elettronico)
CARGOEVOLUTION è una piattaforma utilizzata da sole aziende di autotrasporto conto terzi dove ciascuna può offrire la disponibilità dei  propri carichi in esubero o "sconvenienti"
Le regole necessarie per poter aderire a questo progetto sono:
<ul>- massima serietà (neutralità verso la clientela altrui);</ul> 	
<ul>- DURC regolari;</ul>
<ul>- assicurazione vettoriale regolare;</ul>
<ul>- pagamento dei vari servizi entro 60 ggdffm;</ul>
<ul>- immatricolazione del proprio parco veicolare in ITALIA;</ul>
</p>
<p>
Il rispetto di questi cinque punti comporterà per ciascun utente un feedback, quale valore aggiunto durante le transazioni tra le parti
Per info la ns. mail è: <p>info\@cargoevolution.com</p>
</p>

</p>


EOF
print "</article>\n";
generateHTMLFooter();
print"</body>\n<html>\n";

