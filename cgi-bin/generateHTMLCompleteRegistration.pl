use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use Path::Class;

require "../cgi-bin/generateHTMLopenTag.pl";
require "../cgi-bin/generateHTMLheader.pl";
require "../cgi-bin/generateHTMLFooter.pl";

sub generateHTMLCompleteRegistration
{
    my $addtional_tags=$_[0];
    my $double_reg=$_[1];

    generateHTMLopenTag();
    generateHTMLheader("Registrazione a cargoevolution","");
    print"<body>\n";
    if( !$addtional_tags )
    {
       if( !$double_reg )
       {
          print "<header>Registrazione eseguita</header>";
       }
       else
       {
          print "<header>Registrazione già eseguita</header>";
       }
       print "<center>\n";
       print "Account attivato, effettual il <a href=\"/login.html\">login</a>";
       #print "<p>\n";
       #print "Controlla la tua email, entro pochi minuti riceverai un messaggio con il link per completare l'attivazione\n";
       #print "</p>\n";
       print "</center>\n";
    }
    else
    {
       if( !$double_reg )
       {
          print "<header>Registrazione eseguita</header>";
          print "<center>\n";
          print "<p>\n";
          print "Account attivato, effettual il <a href=\"/login.html\">login</a>";
          print "</p>\n";
          print "</center>\n";
       }
       else
       {
          print "<header>Registrazione già eseguita</header>";
          print "<center>\n";
          print "<p>\n";
          print "Controlla la tua email, entro pochi minuti riceverail un messaggio con il link per completare l'attivazione\n";
          print "</p>\n";
          print "</center>\n";
       }
    }

    generateHTMLFooter();
    print"</body>\n<html>\n";
}
1;
