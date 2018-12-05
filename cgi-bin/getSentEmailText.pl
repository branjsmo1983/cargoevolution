require "../cgi-bin/read_file_STUB.pl";

sub getSentEmailText
{
   my $mid=$_[0];
   
   my $PG_COMMAND=qq{select tmp_dat from messages2 RIGHT OUTER JOIN transactions  ON( messages2.id = transactions.message_id) where messages2.id =?};
    
    my $database_name=getDatabaseName();
    
    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "cargoevo_postgres", "Afirmkick_02")
       or die $DBI::errstr;
       
    my $sth = $dbh->prepare($PG_COMMAND)
       or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute( $mid )
       or die "Couldn't execute statement: " . $dbh->errstr;

    my @row = $sth->fetchrow_array;
    
    if( (scalar @row) == 0 )
    {
        # Could not find the transaction in the database
        exit;
    }
    
    my $full_path = $row[0];
    my $mailBody = read_file_STUB( $full_path );
    
    $sth->finish;
    $dbh->disconnect;
    
    return $mailBody;
}
1;
