require "../cgi-bin/getAdminHash.pl";

sub generateHTMLFooter
{
   my $message=$_[0];
   my $uid = $_[1];
   my $dispMsg;

   if ( getAdminHash() eq $uid or "2cff49e7376ab1b303b40e5e66c3795a" eq  $uid or "23f83ef1ed40e8cf5e7184591640e4aa" eq $uid )
   {
     $dispMsg = "<p>" . $message . "</p>";
   }
   else
   {
     $dispMsg = "";
   }
   print "<footer><p><img src=\"/img/cargoevo.png\" height=\"64\" width=\"64\"> Copyright &copy; Cargoevolution di Cecutti Fabrizio - P.IVA: 029221090300 - Tel: +39 349 4496216</p><p> email: fabrizio\@cargoevolution.com</p>$dispMsg\n";
   # <p>$message</p>
   print "<a href=\"https://www.facebook.com/Cargoevolution-364102520719156/?ref=br_rs\" class=\"btn btn-default btn-lg\" target=\"_blank\" >
                 <img src=\"/img/facebook.png\" height=\"32\" width=\"32\">
                 <i class=\"fa fa-facebook fa-fw\"></i>
                 <span class=\"network-name\"></span>Seguici su Facebook
               </a> </footer>";
}
1;
