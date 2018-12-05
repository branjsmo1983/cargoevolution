use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use Path::Class;
use DBI;
use DBD::Pg;
use DBD::Pg qw(:pg_types);
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/getTripInformationFromMID.pl";
require "../cgi-bin/getEmailFromUserID.pl";

sub insertRegionalTrips
{
  my $mid = $_[0];
  my $pur = $_[1];
  my $dr = $_[2];
  my $my_id = $_[3];

  my $my_email = getEmailFromUserID( $my_id );
  #print header (-charset => 'UTF-8');
  #print "\$mid = $mid , \$pur = $pur , \$dr = $dr\n";

  my $tripInfo = getTripInformationFromMID( $mid );
  $tripInfo = $tripInfo . "\nPer avere il recapito telefonico del contatto accedi su cargoevolution.com:\n\n http://www.cargoevolution.com/login.html\n";

  my $database_name=getDatabaseName();
  my $db_username=getDatabaseUsername();
  my $db_pwd=getDatabasePwd();

  # connect to the database
  my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
     or die $DBI::errstr;

  my $PG_COMMAND = "SELECT email from users3 where email != ? and (region = ? or region = ?) and email NOT IN (select users3.email from users3 RIGHT OUTER JOIN blacklist ON blacklist.uid2block =  users3.id where blacklist.uid =?)";

  my $sth = $dbh->prepare($PG_COMMAND)
    or die "Couldn't prepare statement: " . $dbh->errstr;

  # $sth->execute( $dr, $my_email, $my_id )
  $sth->execute(  $my_email, $pur, $dr,  $my_id )
      or die "Can't execute SQL statement SELECT: $dbh::errstr\n";

   my $subject = "Viaggio dalla/alla tua regione";
    while (my @row = $sth->fetchrow_array) {
        my $demail = $row[0];
        #  ;
        my $PG_COMMAND0  = "select email from users3 where id IN (select uid AS id from regions where region = ?) and email=? and id IN (select uid AS id from regions where region = ?)";
        my $sth0 = $dbh->prepare($PG_COMMAND0)
          or die "Couldn't prepare statement: " . $dbh->errstr;

        $sth0->execute( $dr, $demail, $pur )
              or die "Can't execute SQL statement INSERT: $dbh::errstr\n";

        my $filter_region;
        my @row2 = $sth0->fetchrow_array;

        if( scalar(@row2) != 0 )
        {
          $filter_region = "False";
        }
        else
        {
          $filter_region = "True";
        }

        $sth0->finish;

        if( $filter_region eq "False" )
        {
          # insert message to be sent into table
          my $PG_COMMAND2  = "INSERT into mail_regional(mail_to, subject, body, mid) VALUES( ?, ?, ?, ?)";
          my $sth2 = $dbh->prepare($PG_COMMAND2)
            or die "Couldn't prepare statement: " . $dbh->errstr;

          #$tripInfo = $dbh->quote( $tripInfo );
          #$subject = $dbh->quote( $subject );

          $sth2->execute( $demail, $subject, $tripInfo, $mid )
              or die "Can't execute SQL statement INSERT: $dbh::errstr\n";
          $sth2->finish;
        }
    }

    $sth->finish;

    # insert  email for the Admin
    $subject = "Admin tools nuovo viaggio";
    my $demail = "fabrizio.eftrasporti\@gmail.it";

    my $PG_COMMAND2  = "INSERT into mail_regional(mail_to, subject, body) VALUES( ?, ?, ?)";
    my $sth2 = $dbh->prepare($PG_COMMAND2)
      or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth2->execute( $demail, $subject, $tripInfo )
        or die "Can't execute SQL statement: $dbh::errstr\n";
    $sth2->finish;


    $sth->finish;
    $dbh->disconnect();
}
1;
