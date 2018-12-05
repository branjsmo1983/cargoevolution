use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";


sub getBuyerID
{
    my $mid= $_[0];
    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();
    
    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;
  
    my $PG_COMMAND="select buyerid from messages2 where id=?";
    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute( $mid )
        or die "Can't execute SQL statement: $dbh::errstr\n";

   my @row2 = $sth->fetchrow_array;
   my $bid;
   if( (scalar @row2) != 0 )
   {
     $bid = $row2[0];
   }
   else
   {
     # STUB
     $bid = undef;
   }

    $sth->finish;
    $dbh->disconnect();

    return $bid;
}
1;
