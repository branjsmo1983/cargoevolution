sub generateHTMLopenTag
{
   my $fh=$_[0];

   if( !$fh )
   {
      print "<html xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"it\">\n";
   }
   else
   {
      print $fh "<html xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"it\">\n";
   }
}
1;
