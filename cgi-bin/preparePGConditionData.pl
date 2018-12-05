use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
print header (-charset => 'UTF-8');
use Path::Class;

require "../cgi-bin/european2AmericanData.pl";

sub preparePGConditionData{

   my $din = $_[0];
   my $ret;
    
   if( $din )
   {
       $ret = european2AmericanData( $din );
   }
   else
   {
       $ret = "skip";
   }
   
   return $ret; 
}
1;
