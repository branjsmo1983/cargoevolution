use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

sub getCompanyNameFromID
{
    # Reteive the emial of the user and generate the input form for the user
    my $mid=$_[0];
    my $PG_COMMAND=qq{SELECT company_name FROM users3 WHERE id IN (SELECT username FROM messages2 where id=?) or id IN (SELECT buyerid FROM messages2 where id=?)};
    
    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();
    
    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;
  
    
    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute( $mid, $mid )
        or die "Can't execute SQL statement: $dbh::errstr\n";
        
    my @row;
    my @results;
    while (@row = $sth->fetchrow_array) {
       push @results, $row[0];
    }

    $sth->finish;
    $dbh->disconnect();
    return @results;
}
1;
