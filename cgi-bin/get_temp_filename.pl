use strict;
use warnings;

use File::Temp;

sub get_temp_filename {
    my $ext=$_[0];
    my $dir=$_[1];
    
    if(  !$ext )
    {
        $ext = '.dat';
    }

    if(  !$dir )
    {
        $dir = '/tmp';
    }

    my $fh = File::Temp->new(
        TEMPLATE => 'TBtempXXXXXXX',
        DIR      => $dir,
        SUFFIX   => $ext,
    );

    return $fh->filename;
}
1;
