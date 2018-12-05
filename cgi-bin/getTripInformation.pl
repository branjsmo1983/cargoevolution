use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getVehicleDetails.pl";
require "../cgi-bin/getVeihcleType.pl";
require "../cgi-bin/american2EuropeanData.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/getEmailFromUserID.pl";
require "../cgi-bin/getPhoneNumbers.pl";


sub getTripInformation
{
    my $messageID=$_[0];

    my $PG_COMMAND=qq{SELECT date_of_loading1, date_of_loading2, pick_up_province, pick_up_region, delivery_province, delivery_region, veihcle_type, notes, username FROM messages2 WHERE id=?};

    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();

    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;


    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute( $messageID )
        or die "Can't execute SQL statement: $dbh::errstr\n";

    my @row2 = $sth->fetchrow_array;
    $sth->finish;
    $dbh->disconnect();

    my @vehicle_details = getVehicleDetails( $messageID );
    my $userID = $row2[8];
    my $email = getEmailFromUserID( $userID );
    my $tel_temp = getPhoneNumbers( $userID );
    my @tel = split /!/, $tel_temp;
    my $office = $tel[1];
    my $mobile = $tel[0];
    my $message_details="";
    #my $message_details=" Contatto: $email\n";
    my $tmp1;
    my $DL1 = $row2[0];
    my $DL2 = $row2[1];
    $DL1 = american2EuropeanData($DL1);
    $DL2 = american2EuropeanData($DL2);
    #$tmp1=" Data di carico A:     $DL1\n";
   # $message_details="$message_details$tmp1";

    if( $DL1 ne $DL2 )
    {
      $tmp1="<li> Data di carico A:     $DL1 </li>";
      $message_details="$message_details$tmp1\n";
      $tmp1= "<li> Data di carico B:  $DL2</li>";
      $message_details="$message_details$tmp1\n";
    }else{
      $tmp1="<li> Data di carico :     $DL1</li>";
    $message_details="$message_details$tmp1\n";
    }
    my $PUP_region = $row2[3];
    my $PUP_province = $row2[2];
    my $DEL_region = $row2[5];
    my $DEL_province = $row2[4];
    my $vtype = $row2[6];
    my $vtype_string = getVeihcleType( $vtype );
  

    $tmp1 = "<li> Luogo di ritiro:    $PUP_province, $PUP_region</li>";
    $message_details="$message_details$tmp1";
    $tmp1 = "<li> Luogo di consegna:  $DEL_province, $DEL_region</li>";
    $message_details="$message_details$tmp1";
    $tmp1 = "<li> Tipologia di mezzo: $vtype_string</li>";
    $message_details="$message_details$tmp1";
    # print vehicle details as well
    my $length = $vehicle_details[2];
    $tmp1 = "<li> Metri di pianale:   $length</li>";
    $message_details="$message_details$tmp1";
    my $weight = $vehicle_details[3];
    $tmp1 = "<li> Peso (tonnellate):  $weight</li>";
    $message_details="$message_details$tmp1";
    my $bay_for_coils = $vehicle_details[4];
    $bay_for_coils = "$bay_for_coils";

    if( $bay_for_coils ne "0" )
    {
       $tmp1 = "<li> Supporto Buca Coils </li>";
       $message_details="$message_details$tmp1";
    }

    my $adr = $vehicle_details[5];
    $adr = "$adr";

    if( $adr ne "0" )
    {
       $tmp1 = "<li> Trasporto ADR </li>";
       $message_details="$message_details$tmp1";
    }

    my $big_volume = $vehicle_details[6];
    $big_volume = "$big_volume";

    if( $big_volume ne "0" )
    {
       $tmp1 = "<li> Grande Volume </li>";
       $message_details="$message_details$tmp1";
    }
    # print notes from user as well
    my $notes=  $row2[7];
    # utf8::decode( $notes );
    if( $notes ne ""){
      $tmp1="<li>Note: $notes </li>";
      $message_details="$message_details$tmp1";
    }

    return $message_details;
}
1;

