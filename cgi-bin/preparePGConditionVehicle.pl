sub preparePGConditionVehicle{
    
    my $PG_string = $_[0];
    my $ret;
    
    if( $PG_string )
    {
        $ret = "$PG_string";
    }
    else
    {
        $ret = "skip";
    }
    
    return $ret;
}
1;

