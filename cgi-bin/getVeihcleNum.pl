sub getVeihcleNum{

   my $vt_string = $_[0];

   @v_type = ("Qualunque", "Telonato", "Aperto", "Frigo", "Autotreno", "Sponda idraulica", "Motrice tax", "Centinato o Aperto" );

   my $search = "$vt_string";

   my %index;
   @index{@v_type} = (0..$#v_type);
   my $index = $index{$search};

   return $index;
}
1;
