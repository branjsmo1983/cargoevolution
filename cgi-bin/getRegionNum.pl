sub getRegionNum{
   my $region_string= $_[0];
    
   my @regions = ("Ovunque",
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

   my $search = "$region_string";

   my %index;
   @index{@regions} = (0..$#regions);
   my $index = $index{$search};              
   
   return $index;
}
1;
