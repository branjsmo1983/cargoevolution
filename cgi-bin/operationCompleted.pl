use strict;
use warnings;

require "../cgi-bin/generateHTMLRedirectionButtons.pl";
require "../cgi-bin/generateHTMLheader.pl";
require "../cgi-bin/generateHTMLopenTag.pl";
require "../cgi-bin/generateHTMLInputForm.pl";
require "../cgi-bin/generateHTMLActionPage.pl";

sub operationCompleted
{
    my $sid = $_[0];
    my $title = $_[1];
    my $from_redirection=$_[2];

    if( $from_redirection )
    {

    }
    else
    {
       print header (-charset => 'UTF-8');
       #print "!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 5.0 Final//IT\" >\n";
    }
    
    generateHTMLopenTag();
    generateHTMLheader("Operation completed");

print <<EOF;
    <body>
    <div>
    <p>
    <center>
EOF

     print "<messages>\n$title\n</messages>\n";

print <<EOF;
    </center>
    </p>
    <div/> 
EOF

    # generateHTMLRedirectionButtons( $ID );
    # go to the welcome page so that the user can deciede what to do
    if( $from_redirection )
    {
       generateHTMLActionPage( "view", $sid, "from_redirection" );
    }
    else
    {
       generateHTMLActionPage( "view", $sid );
    }

    print <<EOF;
    </body>
    </html>

EOF

}
1;
