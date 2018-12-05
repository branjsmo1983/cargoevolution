use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/generatePGTimestamp.pl";
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

sub insertTransaction
{
    my $messageID=$_[0];
    my $link=$_[1];
    my $tmp_filename=$_[2];
    # create time stamp
    my $creation_time = generatePGTimestamp();
    my $PG_COMMAND=qq{INSERT INTO transactions(\"link_confirm_page\", \"creation_time\", \"message_id\", \"tmp_dat\" ) VALUES(\'$link\', \'$creation_time\', \'$messageID\', \'$tmp_filename\')};
    
    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();
    
    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name","$db_username", "$db_pwd" )
       or die $DBI::errstr;
  
    
    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute()
        or die "Can't execute SQL statement: $dbh::errstr\n";
    
    $sth->finish;
    $dbh->disconnect();
}
1;
