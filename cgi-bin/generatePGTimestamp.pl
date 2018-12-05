sub generatePGTimestamp{
    use POSIX ();
    my @local = ( gmtime(time + 3600 ) )[0..5];
    my $timestamp = POSIX::strftime( '%Y-%m-%d %H:%M:%S', @local);
    
    return $timestamp;
}
1;
