use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";

sub tets_returning
{
    my $PG_COMMAND=qq{insert into users2(username, password) values('Stefano3', 'define') RETURNING id};


    my $database_name=getDatabaseName();
    
    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "cargoevo_postgres", "Afirmkick_02")
       or die $DBI::errstr;
  
    
    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute()
        or die "Can't execute SQL statement: $dbh::errstr\n";
        
    my @row2 = $sth->fetchrow_array;
    
    foreach my $val ( @row2 )
    {
        print "\$val=$val\n";
    }
    
    print "<<<<<<<<<<<<<<<<<<<<<<\n";
}
1;
