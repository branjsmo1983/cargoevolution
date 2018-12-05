require "../cgi-bin/generateHTMLopenTag.pl";
require "../cgi-bin/generateHTMLheader.pl";

sub generateErrorPage{

    generateHTMLopenTag();
    generateHTMLheader("Cargoevolution", $addtional_tags);

    print '<style> .imgContainer { float:left; } figcaption { font-size: 32px; } .msgContainer { float:bottom; font-size: 32px; color: black;} hr { border-color : gray; }
    </style>';
    print '<style>
    .imgContainer:hover {
        border: 8px solid #00cc00;
    }
    </style>';

    #print "\n<script type=\"text/javascript\" src=\"/notifications.js\">\n</script>\n";

    print "<header>\n<h1>$title&nbsp&nbsp";
    print "<\/h1>\n";
    # insert link to user account managenet

    print "<p><font color=\"white\"> </font></p>";
    print "<body>\n";
    my $message = $_[0];
    print "<h1>$message</h1>\n";
    print "<p><a href=\"javascript:history.go(-1)\">[Clicca qui per tornare indietro]</a></p>";

    #generateHTMLFooter( );
    print "</body>\n";
}
1;
