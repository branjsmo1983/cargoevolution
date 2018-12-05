use DBI;
use strict;
use warnings;

require "../cgi-bin/american2EuropeanData.pl";
require "../cgi-bin/getVeihcleType.pl";
require "../cgi-bin/getVehicleDetails.pl";

sub printTripInformation{
    my $fh = $_[0]; # file handle used for printing
    my $trip_details_string = $_[1];
    my $lang = $_[2];
    my $print_email = $_[3];
    my $detailed_description= $_[4];
    # my @vehicle_details=@{$_[3]};
    
    if( $fh eq "STDOUT")
    {
        $fh=*STDOUT;
    }
    
    my @trip_details = split("#", $trip_details_string);
    my @vehicle_details = getVehicleDetails( $trip_details[0] );
    
    print $fh "*****************************************************\n";
    
    if( $lang =~ /it/i )
    {
        my $applicant = $trip_details[3];
        
        if( $print_email )
        {
           print $fh "Richiedente:             $applicant\n";
        }
        
        my $DL1 = $trip_details[8];
        my $DL2 = $trip_details[9];
        $DL1 = american2EuropeanData($DL1);
        $DL2 = american2EuropeanData($DL2);
        print $fh "Data di carico:    $DL1\n";
        
        if( $DL1 ne $DL2 )
        {
            print $fh "Data di carico alt.: $DL2\n";
        }
        my $PUP_region = $trip_details[11];
        my $PUP_province = $trip_details[12];
        my $DEL_region = $trip_details[13];
        my $DEL_province = $trip_details[14];
        my $vtype = $trip_details[15];
        my $vtype_string = getVeihcleType( $vtype );
        
        print $fh "Luogo di ritiro:   $PUP_province, $PUP_region\n";
        print $fh "Luogo di consegna: $DEL_province, $DEL_region\n";
        
        if(  $detailed_description )
        {
           print $fh "Tipologia di mezzo:$vtype_string\n";
           # print vehicle details as well
           my $length = $vehicle_details[2];
           print $fh "Metri di pianale:  $length\n";
           my $weight = $vehicle_details[3];
           print $fh "Peso (tonnellate): $weight\n";
        }
        
        my $bay_for_coils = $vehicle_details[4];
        $bay_for_coils = "$bay_for_coils";
        
        if( $bay_for_coils ne "0" )
        {
            print $fh "Supporto Buca Coils\n";
        }
        
        my $adr = $vehicle_details[5];
        $adr = "$adr";
        
        if( $adr ne "0" )
        {
            print $fh "Trasporto ADR\n";
        }
        
        my $big_volume = $vehicle_details[6];
        $big_volume = "$big_volume";
        
        if( $big_volume ne "0" )
        {
            print $fh "Grande Volume\n";
        }
        
    }
    else
    {
        print $fh "ERROR(formatTripInformation): Language $lang not supported\n"
    }
    
    print $fh "*****************************************************\n";

}
1;

