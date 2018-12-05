use strict;

sub read_file_bin
{
   my $file = $_[0];
   local $/;
   open(my $FH, "<$file") or die "Can't open $file file for reading!";
   binmode($FH);
   my $string = <$FH>;
   close $FH;

   return $string;
}
1;
