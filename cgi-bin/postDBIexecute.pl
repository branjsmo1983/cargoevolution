use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
use Path::Class;
use DBI;

# the maximum number of options is 7
sub postDBIexecute{

    my $sth = $_[0];
    my $options = $_[1];
    
    my @ff=split( /:/, $options);
    my $num_options=scalar @ff;
    
    if( $num_options == 0 )
    {
        $sth->execute()
            or die "Can't execute SQL statement: $dbh::errstr\n";
    }
    elsif( $num_options == 1 )
    {
        $sth->execute( @ff[0] )
            or die "Can't execute SQL statement: $dbh::errstr\n";
    }
    elsif( $num_options == 2 )
    {
        $sth->execute( @ff[0], @ff[1] )
            or die "Can't execute SQL statement: $dbh::errstr\n";
    }
    elsif( $num_options == 3 )
    {
        $sth->execute( @ff[0], @ff[1], @ff[2] )
            or die "Can't execute SQL statement: $dbh::errstr\n";
    }
    elsif( $num_options == 4 )
    {
        $sth->execute( @ff[0], @ff[1], @ff[2], @ff[3] )
            or die "Can't execute SQL statement: $dbh::errstr\n";
    }
    elsif( $num_options == 5 )
    {
        $sth->execute( @ff[0], @ff[1], @ff[2], @ff[3], @ff[4] )
            or die "Can't execute SQL statement: $dbh::errstr\n";
    }
    elsif( $num_options == 6 )
    {
        $sth->execute( @ff[0], @ff[1], @ff[2], @ff[3], @ff[4], @ff[5] )
            or die "Can't execute SQL statement: $dbh::errstr\n";
    }
    elsif( $num_options == 7 )
    {
        $sth->execute( @ff[0], @ff[1], @ff[2], @ff[3], @ff[4], @ff[5], @ff[6] )
            or die "Can't execute SQL statement: $dbh::errstr\n";
    }
    elsif( $num_options == 8 )
    {
        $sth->execute( @ff[0], @ff[1], @ff[2], @ff[3], @ff[4], @ff[5], @ff[6], @ff[7] )
            or die "Can't execute SQL statement: $dbh::errstr\n";
    }
    elsif( $num_options == 9 )
    {
        $sth->execute( @ff[0], @ff[1], @ff[2], @ff[3], @ff[4], @ff[5], @ff[6], @ff[7], @ff[8] )
            or die "Can't execute SQL statement: $dbh::errstr\n";
    }
    elsif( $num_options == 10 )
    {
        $sth->execute( @ff[0], @ff[1], @ff[2], @ff[3], @ff[4], @ff[5], @ff[6], @ff[7], @ff[8], @ff[9] )
            or die "Can't execute SQL statement: $dbh::errstr\n";
    }
    elsif( $num_options == 11 )
    {
        $sth->execute( @ff[0], @ff[1], @ff[2], @ff[3], @ff[4], @ff[5], @ff[6], @ff[7], @ff[8], @ff[9], @ff[10] )
            or die "Can't execute SQL statement: $dbh::errstr\n";
    }
    elsif( $num_options == 12 )
    {
        $sth->execute( @ff[0], @ff[1], @ff[2], @ff[3], @ff[4], @ff[5], @ff[6], @ff[7], @ff[8], @ff[9], @ff[10], @ff[11] )
            or die "Can't execute SQL statement: $dbh::errstr\n";
    }
    elsif( $num_options == 13 )
    {
        $sth->execute( @ff[0], @ff[1], @ff[2], @ff[3], @ff[4], @ff[5], @ff[6], @ff[7], @ff[8], @ff[9], @ff[10], @ff[11], , @ff[12] )
            or die "Can't execute SQL statement: $dbh::errstr\n";
    }
    elsif( $num_options == 14 )
    {
        $sth->execute( @ff[0], @ff[1], @ff[2], @ff[3], @ff[4], @ff[5], @ff[6], @ff[7], @ff[8], @ff[9], @ff[10], @ff[11], , @ff[12], @ff[13]  )
            or die "Can't execute SQL statement: $dbh::errstr\n";
    }
    else
    {
        $sth->execute()
            or die "Can't execute SQL statement: $dbh::errstr\n";
    }
}
1;
