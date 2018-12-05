sub escapeTextForPostgres
{
    my $in_text=$_[0];
    my $ret_text="E\'";
    
    # use regex to actually scape text
    $in_text =~ s/\'/\\\'/g;
    # escape forward slash
    $in_text =~ s/\//\\\//g;
    # escape backslash
    $in_text =~ s/\\/\\\\/g;
    $in_text =~ s/\r//g; # remove windows like end of the line
    
    $ret_text = "$ret_text$in_text";
    # close the escape 
    $ret_text = "$ret_text\'";
    #$ret_text = utf8::upgrade($ret_text);
    
    return $ret_text;
}
1;
