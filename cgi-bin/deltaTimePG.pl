sub deltaTimePG
{
   my $t1=$_[0]; # current time
   my $t2=$_[1];

   # return delta in minutes
   my $delta_min;

   # split date from time
   my @t1_v = split / /, $t1;
   my @t2_v = split / /, $t2;

   my $tt1=$t1_v[0];
   my $tt2=$t2_v[0];


   if( $t1_v[0] gt $t2_v[0] )
   {
     # different day return a big delta (does not work on the turn of the day)
     $delta_min=6000;
   }
   else
   {
     $delta_min = 0;
     my @h1_v = split /:/, $t1_v[1];
     my @h2_v = split /:/, $t2_v[1];

     $delta_min = $delta_min + ($h1_v[0] - $h2_v[0]) * 60;
     # hadle minuts, the difference may be negative
     my $dmi = $h1_v[1] - $h2_v[1];

     if( $dmi < 0 )
     {
        $dmi = $dmi + 60;
     }
     
     $delta_min = $delta_min + $dmi;
   }

    return $delta_min;
}
1;
