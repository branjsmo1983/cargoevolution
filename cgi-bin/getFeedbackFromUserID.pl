use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

sub getFeedbackFromUserID
{
    # Reteive the emial of the user and generate the input form for the user
    my $feedback;
    my $userID=$_[0];
    my $PG_COMMAND=qq{SELECT feedback FROM users3 WHERE id=?};
    
    # connect to the database
    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();
    
    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;
  
    
    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute( $userID );
    my @row2 = $sth->fetchrow_array;
    if( (scalar @row2) != 0 )
    {
        # username found
        $feedback = $row2[0];
    }
    else
    {
        $feedback = 0;
    }
    
    $sth->finish();
    $dbh->disconnect();
    
    return $feedback;
}
1;
