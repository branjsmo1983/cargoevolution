use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";


sub getChatInsertion{

    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();

    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;

    my $mid=$_[0];
    my $PG_COMMAND=qq{SELECT uid,text,creation_time, did, read FROM chats WHERE mid=? order by creation_time ASC, uid ASC};

    my $sth = $dbh->prepare($PG_COMMAND)
       or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute( $mid )
        or die "Can't execute SQL statement: $dbh::errstr\n";

#    $sth->finish;
    $dbh->disconnect();

    return $sth;
}
1;
