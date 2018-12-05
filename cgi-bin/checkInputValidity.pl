sub checkInputValidity{

use Scalar::Util qw(looks_like_number);
use strict;
use warnings;

my $validity_status= 0;
my $type = $_[0];
my $val  = $_[1];

    if( $type eq "text" )
    {
        if( $val =~ /\\<>\// or $val =~ // or ! $val )
        {
            # field not valid
            $validity_status = 0;
        }
        else
        {
            $validity_status = 1;
        }
    }
    elsif ($type eq "date" )
    {
    	$_ = $val;
    	$val =~ s/\//\-/g;
        # print "$val\n";
        my @fields = split(/\-/, $val);
        # check the number thus obtained
        $validity_status = 1;
        foreach my $field (@fields)
        {
            # print "field = $field\n";
            if (looks_like_number($field))
            {
            }
            else
            {
                $validity_status= 0;
            }
            # check the number of elements
            my $num_el = scalar @fields;
            if( $num_el != 3 )
            {
                $validity_status= 0;
            }
            else
            {
                # TODO: check also the single numbers
                my $day = $fields[0];
                my $month = $fields[1];
                my $year = $fields[2];
            }
        }
    }
    elsif ($type eq "select" )
    {
        if( $val == 0 )
        {
            # field not valid
            $validity_status = 0;
        }
        else
        {
            $validity_status = 1;
        }
    }
    else
    {
        $validity_status = 0;
    }
    
    return $validity_status;
}
1;

