sub generateHTMLRedirectionButtons{
    my $username = $_[0];
    
    # pass username for the following scripts
    print "<fieldset>\n<center>\n<p>\n";
    print "<form action=\"/cgi-bin/login_succ.pl\" method=\"post\" enctype=\"multipart/form-data\">";
    print "<div>\n<input id=\"username\" name=\"username\" type=\"hidden\" value=\"$username\">\n</div>\n";

    print <<EOF;
    <div>
       <button type="submit" class="button positive">
       <img alt="ok" src="http://www.blueprintcss.org/blueprint/plugins/buttons/icons/tick.png" /> 
       Inserisci Annuncio
       </button>
    </div>
    </form>
    </p>
EOF

    # pass username for the following scripts
    print "<p>\n<form action=\"/cgi-bin/login_succ_view.pl\" method=\"post\" enctype=\"multipart/form-data\">";
    print "<div>\n<input id=\"username\" name=\"username\" type=\"hidden\" value=\"$username\">\n</div>\n";

    print <<EOF;
    <div>
       <button type="submit" class="button positive">
       <img alt="ok" src="http://www.blueprintcss.org/blueprint/plugins/buttons/icons/tick.png" /> 
       Consulta Annunci
       </button>
    </div>
    </form>
    </p>
EOF
    print "<center>\n</fieldset>\n";
}
1;
