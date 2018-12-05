use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;
use File::Basename;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

sub eraseTransaction
{
   my $mid=$_[0];
    
   my $database_name=getDatabaseName();
   my $db_username=getDatabaseUsername();
   my $db_pwd=getDatabasePwd();
       
   # connect to the database
   my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
      or die $DBI::errstr;
   # remove also temporary files
   my $PG_COMMAND_SEL=qq{select link_confirm_page, tmp_dat from transactions WHERE message_id=?};
   
   my $sth = $dbh->prepare($PG_COMMAND_SEL)
      or die "Couldn't prepare statement: " . $dbh->errstr;

   $sth->execute( $mid )
      or die "Can't execute SQL statement: $dbh::errstr\n";
   
   # retrieve the filenames from the query
   my @row2 = $sth->fetchrow_array;
   my $tmp_dat_fname = $row2[1];
   my ($tname, $tpath, $tsuffix) = fileparse($tmp_dat_fname, ".dat");
   my $tmp_html_fname = $row2[0];
   
   # delete temporary files
   unlink $tmp_dat_fname;
   unlink $tmp_html_fname;
   
   my $PG_COMMAND=qq{DELETE FROM transactions WHERE message_id=?};
   $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

   $sth->execute( $mid )
      or die "Can't execute SQL statement: $dbh::errstr\n";
   
   $sth->finish;
   $dbh->disconnect;
   
   return $tname;
}
1;
