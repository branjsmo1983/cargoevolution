sub american2EuropeanData
{
    my $val = $_[0];
    my $date_format;
    my $ret;
    # check if the date is the american format
    if( $val =~ /\-/ )
    {
        $date_format = "american";
        $val =~ s/\-/\//g;
        my @fields = split(/\//, $val);
        my $num_el = scalar @fields;
        if( $num_el != 3 )
        {
          
        }
        else
        {
            my $day = $fields[2];
            my $month = $fields[1];
            my $year = $fields[0];
            $ret = "$day\/$month\/$year";
        }
    }
    else
    {
        $date_format = "european";
        $ret = $val;
    }
    
    return $ret;
}
1;
