use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use Path::Class;

require "../cgi-bin/generateHTMLopenTag.pl";
require "../cgi-bin/generateHTMLheader.pl";
require "../cgi-bin/generateHTMLFooter.pl";

sub generateHTMLCompleteResetPwd
{
    my $addtional_tags=$_[0];

    generateHTMLopenTag();
    generateHTMLheader("Reset password","");
    print"<body>\n";
    if( !$addtional_tags )
    {
       print "<header><h1>Email spedita</h1></header>";
       print "<center>\n";
       print "<p>\n";
       print "Controlla la tua email, entro pochi minuti riceverai un messaggio con il link per completare l'attivazione\n";
       print "</p>\n";
       print "</center>\n";
    }
    else
    {
       if( $addtional_tags eq "double_insertion" )
       {
          print "<header><h1>Email già spedita</h1></header>";
       }
       elsif( $addtional_tags eq "pwd_changed" )
       {
          print "<header><h1>Password cambiata con successo</h1></header>";
       }
       elsif( $addtional_tags eq "wrong_code" )
       {
          print "<header><h1>Link errato</h1></header>";
       }
       else
       {
          print "<header><h1>Email non trovata</h1></header>";
       }
       
       print "<center>\n";
       print "<p>\n";
       print "Torna alla pagina iniziale <a href=\"/login.html\">login</a>";
       print "</p>\n";
       print "</center>\n";
    }

    generateHTMLFooter();
    print"</body>\n<html>\n";
}
1;
