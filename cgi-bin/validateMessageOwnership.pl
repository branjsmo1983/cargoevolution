use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use strict;
use warnings;
use DBI;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

sub validateMessageOwnership
{
    my $ID = $_[0];
    my $messageID = $_[1];
    my $ret;
    
    my $PG_COMMAND=qq{SELECT status FROM messages2 WHERE id=? and username=?};
    
    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();
    
    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;
  
    
    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute( $messageID, $ID )
        or die "Can't execute SQL statement: $dbh::errstr\n";
     
    my @row2 = $sth->fetchrow_array;
    
    if( (scalar @row2) != 0 )
    {
        # User in database
        $ret = "True";
    }
    else
    {
        # User not in database
        $ret = "False";
        generateErrorPage("ERROR: utente non abilitato all'operazione");
    }
    
    $sth->finish;
    $dbh->disconnect();
    return $ret;
}
1;
