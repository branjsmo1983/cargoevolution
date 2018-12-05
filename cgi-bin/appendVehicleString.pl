sub appendVehicleString
{
   my $vehicle_type_string=$_[0];
   my $flag=$_[1];
   
   my $separator;
   
      
   if( $flag )
   {
      $vehicle_type_string="$vehicle_type_string#1";
   }
   else
   {
      $vehicle_type_string="$vehicle_type_string#0";
   }
   
   return $vehicle_type_string;
}
1;
