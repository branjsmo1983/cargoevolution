sub getRegionIT{
    my $region_number= $_[0];
    
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
               
     my $len= scalar @regions;
     if( $region_number >= $len or $region_number < 0 )
     {
        # error the required region does not exist
        return $regions[0];
     }
     else
     {
        return $regions[$region_number];
     }
}
1;
