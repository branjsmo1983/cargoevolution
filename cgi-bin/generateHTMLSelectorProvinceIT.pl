sub generateHTMLSelectorProvinceIT{

    my $region = $_[0];
    my $name = $_[1];
    my $province = $_[2];
    my $from_input_form = $province;

    if    ($region == 1 )
    {
        @province = ("Chieti", "L'Aquila", "Pescara", "Teramo" );
    }
    elsif ($region == 2 )
    {
        @province = ("Matera", "Potenza" );
    }
    elsif ($region == 3 )
    {
        @province = ("Catanzaro", "Cosenza", "Crotone", "Reggio di Calabria", "Vibo Valentia" );
    }
    elsif ($region == 4 )
    {
        @province = ("Avellino", "Benevento", "Caserta", "Napoli", "Salerno" );
    }
    elsif ($region == 5 )
    {
        @province = ( "Bologna", "Ferrara", "Forl&#204-Cesena", "Modena", "Parma", "Piacenza", "Ravenna", "Reggio nell'Emilia", "Rimini" );
    }
    elsif ($region == 6 )
    {
        @province = ( "Gorizia", "Pordenone", "Trieste", "Udine" );
    }
    elsif ($region == 7 )
    {
        @province = ( "Frosinone", "Latina", "Rieti", "Roma", "Viterbo" );
    }
    elsif ($region == 8 )
    {
        @province = ( "Genova", "Imperia", "La Spezia", "Savona" );
    }
    elsif ($region == 9 )
    {
        @province = ( "Bergamo", "Brescia", "Como", "Cremona", "Lecco", "Lodi", "Mantova", "Milano", "Monza e della Brianza", "Pavia", "Sondrio", "Varese" );
    }
    elsif ($region == 10 )
    {
        @province = ( "Ancona", "Ascoli Piceno", "Fermo", "Macerata", "Pesaro e Urbino" );
    }
    elsif ($region == 11 )
    {
        @province = ( "Campobasso", "Isernia" );
    }
    elsif ($region == 12 )
    {
        @province = ( "Alessandria", "Asti", "Biella", "Cuneo", "Novara", "Torino", "Verbano-Cusio-Ossola", "Vercelli" );
    }
    elsif ($region == 13 )
    {
        @province = ( "Bari", "Barletta-Andria-Trani", "Brindisi", "Foggia", "Lecce", "Taranto" );
    }
    elsif ($region == 14 )
    {
        @province = ( "Cagliari", "Carbonia-Iglesias", "Medio Campidano", "Nuoro", "Ogliastra", "Olbia-Tempio", "Oristano", "Sassari" );
    }
    elsif ($region == 15 )
    {
        @province = ( "Agrigento", "Caltanissetta", "Catania", "Enna", "Messina", "Palermo", "Ragusa", "Siracusa", "Trapani" );
    }
    elsif ($region == 16 )
    {
        @province = ( "Arezzo", "Firenze", "Grosseto", "Livorno", "Lucca", "Massa-Carrara", "Pisa", "Pistoia", "Prato", "Siena" );
    }
    elsif ($region == 17 )
    {
        @province = ( "Bolzano/Bozen", "Trento" );
    }
    elsif ($region == 18 )
    {
        @province = ( "Perugia", "Terni" );
    }
    elsif ($region == 19 )
    {
        @province = ( "Valle d'Aosta/Vall&#233e d'Aoste" );
    }
    elsif ($region == 20 )
    {
        @province = ( "Belluno", "Padova", "Rovigo", "Treviso", "Venezia", "Verona", "Vicenza" );
    }
    else
    {
        @province = ("Ovunque", $region);
    }

    my $selected;

    if( $province == 0 )
    {
	$selected="selected";
    }
    else
    {
	$selected="";
    }
    print  "<select id=\"$name\" name=\"$name\">";
    if ( $from_input_form )
    {
       print  "<option value=\"0\" $selected>Ovunque</option>\n";
    }


    my $i=1;

    foreach $p (@province)
    {
	if( $province == $i )
	{
	   $selected="selected";
	}
	else
	{
	   $selected="";
	}
        print "<option value=\"$i\" $selected>$p</option>";
        $i = $i+1;
    }
    print <<EOF;
    </select>
EOF

}
1;
