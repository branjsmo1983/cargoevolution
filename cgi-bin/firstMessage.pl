use DBI;
use strict;
use warnings;
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

sub firstMessage
{
    my $mid = $_[0];
    my $uid = $_[1];
    my $Myid = $_[2];

    my $PG_COMMAND ="select * from chats where mid=? and did=? and  uid=?";
    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();
    
    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;
  
    
    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute( $mid, $uid, $Myid )
        or die "Can't execute SQL statement: $dbh::errstr\n";
        
    my @row;
	my $cnt = 0;
	
	while( my $i=$sth->fetchrow_array )
	{
	  $cnt = $cnt + 1;
	}
	
	if( $cnt )
	{
	   return "False";
	}
	else
	{
	   return "True";
	}
	
     $sth->finish;
     $dbh->disconnect();
}
1;
