use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/escapeTextForPostgres.pl";

sub insertMessageChat
{
    my $mid= $_[0];
    my $uid=$_[1];
    my $timestamp=$_[2];
    my $text=$_[3];
    my $link="none";
    $text = escapeTextForPostgres($text);
    
    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();
    
    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;
  
    my $PG_COMMAND="insert into message_chats(mid, uid, creation_time, text, link) values(\'$mid\', \'$uid\',  TIMESTAMP WITH TIME ZONE \'$timestamp\+01\', $text, \'$link\') RETURNING id";
    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute()
        or die "Can't execute SQL statement: $dbh::errstr\n";
        
    my $row = $sth->fetchrow_array;
    $sth->finish;
    $dbh->disconnect();
    
    return $row;
}
1;
