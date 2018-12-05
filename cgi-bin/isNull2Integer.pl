sub isNull2Integer
{
    my $val=$_[0];
    my $ret;

   # handle the boolean conditions
   if( $val )
   {
      $ret = 1;
   }
   else
   {
      $ret = 0;
   }
   
   return $ret;
}
1;
