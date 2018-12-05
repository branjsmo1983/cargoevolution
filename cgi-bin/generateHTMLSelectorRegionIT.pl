sub generateHTMLSelectorRegionIT{

    my $type = $_[0];
    my $selected = $_[1];
    @regions = ("Ovunque",
                "Abruzzo",
                "Basilicata",
                "Calabria",
                "Campania",
                "Emilia Romagna",
                "Friuli Venezia Giulia",
                "Lazio",
                "Liguria",
                "Lombardia",
                "Marche",
                "Molise",
                "Piemonte",
                "Puglia",
                "Sardegna",
                "Sicilia",
                "Toscana",
                "Trentino-Alto Adige",
                "Umbria",
                "Valle Aosta",
                "Veneto");
    print  "<select id=\"$type\" ";
    print  "name=\"$type\" >";
    #print  "<option value=\"0\">(please select:)</option>\n";
    
    my $cnt;
    $cnt = 0;
    
    foreach $p (@regions)
    {
        if(  $cnt == $selected )
        {
            print "<option value=\"$cnt\" selected>$p</option>\n";
        }
        else
        {
            print "<option value=\"$cnt\">$p</option>\n";
        }
        
        $cnt = $cnt +1;
    }

    print "</select>\n";
}
1;
