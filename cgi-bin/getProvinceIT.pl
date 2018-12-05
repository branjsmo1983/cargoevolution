# this has to be used not for HTML but for postgres
sub getProvinceIT{
    my $region= $_[0];            # region number
    my $province_number= $_[1];   # province number
    my @province;

    if    ($region == 1 )
    {
        @province = ("Ovunque", "Chieti", "LAquila", "Pescara", "Teramo" );
    }
    elsif ($region == 2 )
    {
        @province = ("Ovunque", "Matera", "Potenza" );
    }
    elsif ($region == 3 )
    {
        @province = ("Ovunque", "Catanzaro", "Cosenza", "Crotone", "Reggio di Calabria", "Vibo Valentia" );
    }
    elsif ($region == 4 )
    {
        @province = ("Ovunque", "Avellino", "Benevento", "Caserta", "Napoli", "Salerno" );
    }
    elsif ($region == 5 )
    {
        @province = ( "Ovunque", "Bologna", "Ferrara", "Forli-Cesena", "Modena", "Parma", "Piacenza", "Ravenna", "Reggio nell Emilia", "Rimini" );
    }
    elsif ($region == 6 )
    {
        @province = ( "Ovunque", "Gorizia", "Pordenone", "Trieste", "Udine" );
    }
    elsif ($region == 7 )
    {
        @province = ( "Ovunque", "Frosinone", "Latina", "Rieti", "Roma", "Viterbo" );
    }
    elsif ($region == 8 )
    {
        @province = ( "Ovunque", "Genova", "Imperia", "La Spezia", "Savona" );
    }
    elsif ($region == 9 )
    {
        @province = ( "Ovunque", "Bergamo", "Brescia", "Como", "Cremona", "Lecco", "Lodi", "Mantova", "Milano", "Monza e della Brianza", "Pavia", "Sondrio", "Varese" );
    }
    elsif ($region == 10 )
    {
        @province = ( "Ovunque", "Ancona", "Ascoli Piceno", "Fermo", "Macerata", "Pesaro e Urbino" );
    }
    elsif ($region == 11 )
    {
        @province = ( "Ovunque", "Campobasso", "Isernia" );
    }
    elsif ($region == 12 )
    {
        @province = ( "Ovunque", "Alessandria", "Asti", "Biella", "Cuneo", "Novara", "Torino", "Verbano-Cusio-Ossola", "Vercelli" );
    }
    elsif ($region == 13 )
    {
        @province = ( "Ovunque", "Bari", "Barletta-Andria-Trani", "Brindisi", "Foggia", "Lecce", "Taranto" );
    }
    elsif ($region == 14 )
    {
        @province = ( "Ovunque", "Cagliari", "Carbonia-Iglesias", "Medio Campidano", "Nuoro", "Ogliastra", "Olbia-Tempio", "Oristano", "Sassari" );
    }
    elsif ($region == 15 )
    {
        @province = ( "Ovunque", "Agrigento", "Caltanissetta", "Catania", "Enna", "Messina", "Palermo", "Ragusa", "Siracusa", "Trapani" );
    }
    elsif ($region == 16 )
    {
        @province = ( "Ovunque", "Arezzo", "Firenze", "Grosseto", "Livorno", "Lucca", "Massa-Carrara", "Pisa", "Pistoia", "Prato", "Siena" );
    }
    elsif ($region == 17 )
    {
        @province = ( "Ovunque", "Bolzano/Bozen", "Trento" );
    }
    elsif ($region == 18 )
    {
        @province = ( "Ovunque", "Perugia", "Terni" );
    }
    elsif ($region == 19 )
    {
        @province = ( "Ovunque", "Valle Aosta" );
    }
    elsif ($region == 20 )
    {
        @province = ( "Ovunque", "Belluno", "Padova", "Rovigo", "Treviso", "Venezia", "Verona", "Vicenza" );
    }
    else
    {
        @province = ("Ovunque", $region);
    }

     my $len= scalar @province;
     if( $province_number >= $len or $province_number < 0 )
     {
        # error the required region does not exist
        return my $empty_str;
     }
     else
     {
        return $province[$province_number];
     }
}
1;
