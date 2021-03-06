use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

sub getNotesFromMessageID
{
    my $userID=$_[0];
    my $PG_COMMAND=qq{SELECT email FROM users3 WHERE id=?};
    
    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();
    
    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;
       
    my $messages_table_name="messages2";
    my $PG_COMMAND=qq{SELECT notes FROM $messages_table_name WHERE id=?};

    my $sth = $dbh->prepare($PG_COMMAND)
       or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute( $messageID )
       or die "Couldn't execute statement: " . $dbh->errstr;

    my @row = $sth->fetchrow_array;
    my $notes = $row[12];
    
    $sth->finish;
    $dbh->disconnect;
    
    return $notes;
}
1;
