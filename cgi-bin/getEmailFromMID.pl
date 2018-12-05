use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getEmailFromUserID.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

sub getEmailFromMID
{
   my $mid=$_[0];
   my $PG_COMMAND=qq{SELECT buyerid FROM messages2 WHERE id=?};
   my $database_name=getDatabaseName();
   my $db_username=getDatabaseUsername();
   my $db_pwd=getDatabasePwd();
   # connect to the database
   my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;

   my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;
   $sth->execute( $mid )
        or die "Can't execute SQL statement: $dbh::errstr\n";

   my @row2 = $sth->fetchrow_array;
   my $uid;
   if( (scalar @row2) != 0 )
   {
     $uid = $row2[0];
   }
   else
   {
     # STUB
     $uid = undef;
   }
   
   $sth->finish;
   $dbh->disconnect();

   my $email=getEmailFromUserID( $uid );
   return $email;
}
1;
