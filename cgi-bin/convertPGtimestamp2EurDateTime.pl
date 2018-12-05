require "../cgi-bin/american2EuropeanData.pl";

sub convertPGtimestamp2EurDateTime
{
   my $t1=$_[0];
   my @date_time;

   my @t1_v = split / /, $t1;
   my $date = $t1_v[0];
   my $time = $t1_v[1];

   $date = american2EuropeanData( $date );

   my $ret="$date $time";
   return $ret;
}
1;
