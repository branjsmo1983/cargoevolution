sub european2AmericanData
{

    my $val = $_[0];
    my $date_format;
    my $ret;
    # check if the date is the american format
    if( $val =~ /\// )
    {
        $date_format = "european";
        $val =~ s/\//\-/g;
        my @fields = split(/\-/, $val);
        my $num_el = scalar @fields;
        if( $num_el != 3 )
        {
          
        }
        else
        {
            my $day = $fields[0];
            my $month = $fields[1];
            my $year = $fields[2];
            $ret = "$year\-$month\-$day";
        }
    }
    else
    {
        $date_format = "american";
        $ret = $val;
    }
    
    return $ret;
}1;
