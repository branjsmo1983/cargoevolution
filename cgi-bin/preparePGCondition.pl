require "../cgi-bin/getRegionIT.pl";

sub preparePGCondition
{
    my $PG_string;
    $PG_string = getRegionIT( $_[0] );

    if( $PG_string eq "Ovunque" )
    {
	$PG_string = "skip";
    }
 
    return $PG_string;   
}
1;
