require "../cgi-bin/getProvinceIT.pl";

sub preparePGConditionProvince{

    my $PG_string;
    $PG_string = getProvinceIT( $_[0], $_[1] );

    if( $PG_string eq "Ovunque" )
    {
	$PG_string = "skip";
    }
 
    return $PG_string;   
}
1;
