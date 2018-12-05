sub limitDecimals
{
    my $f=$_[0];

    my $s = sprintf('%.1f', $f);
    $s =~ s/\.?0*$//;

    return $s;

}
1;
