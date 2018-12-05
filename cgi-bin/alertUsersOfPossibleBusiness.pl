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
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
require "../cgi-bin/generateHTMLheader.pl";
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/validateUserID.pl";
require "../cgi-bin/generatePGTimestamp.pl";
require "../cgi-bin/american2EuropeanData.pl";
require "../cgi-bin/generateHTMLopenTag.pl";
require "../cgi-bin/getVeihcleType.pl";
require "../cgi-bin/generateHTMLSelectorRegionIT.pl";
require "../cgi-bin/getVeihcleType.pl";
require "../cgi-bin/getRegionIT.pl";
require "../cgi-bin/getEmailFromUserID.pl";
require "../cgi-bin/sendEmailFunct.pl";
require "../cgi-bin/queueEmail.pl";

sub alertUsersOfPossibleBusiness
{
  my $mid = $_[0];

  # Retieve data from Database
  my $database_name=getDatabaseName();
  my $db_username=getDatabaseUsername();
  my $db_pwd=getDatabasePwd();

  # connect to the database
  my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
     or die $DBI::errstr;

  my $PG_COMMAND="select trucks.uid, messages2.pick_up_region, messages2.pick_up_province, messages2.date_of_loading1, messages2.date_of_loading2, messages2.username, messages2.veihcle_type, messages2.delivery_region  from trucks INNER JOIN messages2 ON (pick_up_region = trucks.region and (delivery_region = trucks.dregion or trucks.dregion IS   NULL ) and (messages2.date_of_loading1 = trucks.day or  messages2.date_of_loading2 = trucks.day)) where messages2.id = ? and (messages2.veihcle_type = trucks.vehicle_type or ( messages2.veihcle_type = '7' and trucks.vehicle_type = '1' or messages2.veihcle_type = '7' and trucks.vehicle_type = '2' )  or ( messages2.veihcle_type = '1' and trucks.vehicle_type = '7' or messages2.veihcle_type = '2' and trucks.vehicle_type = '7' ) or messages2.veihcle_type = '0')  ORDER BY trucks.uid, day DESC";
  my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

  $sth->execute( $mid )
      or die "Couldn't execute statement: " . $dbh->errstr;

  my $cnt = 1;
  my $current_email;
  my $mail_body;
  my $subject="Possibilità di business su Cargoevolution";

  my @row;
  while(@row = $sth->fetchrow_array){
    my $uid_truck = $row[0];
    my $pur = $row[1];
    my $pup = $row[2];
    my $date1 = american2EuropeanData($row[3]);
    my $date2 = american2EuropeanData($row[4]);
    my $uid_cargo = $row[5];
    my $vt = $row[6];
    my $vname = getVeihcleType( $vt );
    my $dregion = $row[7];

    my $email_truck = getEmailFromUserID( $uid_truck );
    my $email_cargo = getEmailFromUserID( $uid_cargo );

    #print "$cnt) Email Camion: $email_truck, Email Merce: $email_cargo, Regione: $pur, Data: $date1, Data Alt.: $date2, Tipologia Veicolo: $vname\n";
    my $subject = "Merce disponibile su Cargoevolution";
    my $body = "Un utente ha inserito della merce che ti può interessare:\n\n";
    $body = $body."Data:    $date1 (Alt. $date2)\n";
    $body = $body."Ritiro:  $pur ($pup)\n";
    # $dregion
    $body = $body."Consegna:  $dregion \n";
    $body = $body."Mezzo:   $vname\n";
    $body = $body."\nAccedi subito a www.cargoevolution.com/login.html\n";

    #print "email TO: $email_truck\n\n";
    #print "Mail body:\n$body\n";
    # sendEmailFunct( $email_truck, $subject, $body );
    queueEmail(  $email_truck, $subject, $body, 0  );

    $cnt = $cnt + 1;
  }
}
1;
