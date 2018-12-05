sub read_file_STUB
{
    my $file = $_[0];
    my $document = do {
        local $/ = undef;
        open my $fh, "< :encoding(UTF-8)", $file
            or die "could not open $file: $!";
        <$fh>;
        };
}
1;
