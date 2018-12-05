use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

sub getPhoneNumFromCompanyName
{
    my $phone;
    my $mobile;
    my $userID=$_[0];
    my $PG_COMMAND=qq{SELECT phone, mobile FROM users3 WHERE company_name=?};
    
    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();
    
    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;
  
    
    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute( $userID )
        or die "Can't execute SQL statement: $dbh::errstr\n";
        
    my @row2 = $sth->fetchrow_array;
    if( (scalar @row2) != 0 )
    {
        # email found
        $phone = $row2[0];
        $mobile = $row2[1];
    }
    else
    {
        $phone = undef;
        $mobile = undef;
    }
    
    $sth->finish;
    $dbh->disconnect();
    
    # prepare retuen value
    my $ret;
    
    if( $phone ne "0" )
    {
      $ret="$phone";
    }
    
    if( $mobile ne "0" )
    {
      if( $phone ne "0" )
      {
         $ret="$ret!$mobile";
      }
      else
      {
         $ret="$mobile";
      }
    }
    
    
    return $ret;
}
1;

