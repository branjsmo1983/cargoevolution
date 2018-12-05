use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use File::Basename;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";

sub getLinkToTempHTML
{
   my $mid=$_[0];
   my $PG_COMMAND=qq{select link_confirm_page from messages2 RIGHT OUTER JOIN transactions  ON( messages2.id = transactions.message_id) where messages2.id =?};
    
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
    
    my ($name, $path, $suffix) = fileparse($full_path);
    
    my $local_address="http://www.cargoevolution.com/tmp/$name";
    
    $sth->finish;
    $dbh->disconnect;
    
    return $local_address;
}
1;
