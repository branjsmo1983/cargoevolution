#!/usr/bin/perl

use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use CGI::Session;
use DBI;
use DBD::Pg;
use DBD::Pg qw(:pg_types);
use strict;
use Fcntl qw(:flock SEEK_END);
use File::Slurp;
use File::Basename;

require "../cgi-bin/american2EuropeanData.pl";
require "../cgi-bin/european2AmericanData.pl";
require "../cgi-bin/generatePGTimestamp.pl";
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/operationCompleted.pl";
require "../cgi-bin/isNull2Integer.pl";
require "../cgi-bin/limitDecimals.pl";
require "../cgi-bin/escapeTextForPostgres.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/generateHTMLCompleteRegistration.pl";
require "../cgi-bin/generateTempHTMLpageForRegistrationCompleted.pl";
require "../cgi-bin/getEmailFromUserID.pl";
require "../cgi-bin/sendEmailFunct.pl";
require "../cgi-bin/read_file_bin.pl";
require "../cgi-bin/appendVehicleString.pl";
require "../cgi-bin/email.pl";
require "../cgi-bin/password.pl";
require "../cgi-bin/getRegionIT.pl";
require "../cgi-bin/getProvinceIT.pl";

print header (-charset => 'UTF-8');
my $q = CGI->new();
$q::POST_MAX = 1024 * 5000;
my $safe_filename_characters = "a-zA-Z0-9_.-";
my $upload_dir = "/home2/cargoevo/public_html/tmp";

my $username = $q->param('username');
my $password = $q->param('password');
my $password_c = $q->param('password_c');
my $uemail = $q->param('uemail');
my $company = $q->param('company');
my $vat_number = $q->param('vat_number');
my $phone = $q->param('phone');
my $mobile = $q->param('mobile');
my $referer = $q->param('referer');
my $address = $q->param('address');
my $register_code = $q->param('register');
my $filename = $q->param('files');
my $region = $q->param('sel_reg');
my $province = $q->param('sel_prov');

my $region_str = getRegionIT( $region );
my $province_str = getProvinceIT( $region, $province );

# get vehicle configuration
my $vehicle_type_string;

my $tractor = $q->param('tractor');
$vehicle_type_string = appendVehicleString($vehicle_type_string, $tractor);

my $tractor_lift = $q->param('tractor_lift');
$vehicle_type_string = appendVehicleString($vehicle_type_string, $tractor_lift);

my $trucks = $q->param('trucks');
$vehicle_type_string = appendVehicleString($vehicle_type_string, $trucks);

my $semitrailer = $q->param('semitrailer');
$vehicle_type_string = appendVehicleString($vehicle_type_string, $semitrailer);

my $semitrailer_fridge = $q->param('semitrailer_fridge');
$vehicle_type_string = appendVehicleString($vehicle_type_string, $semitrailer_fridge);

my $semitrailer_open = $q->param('semitrailer_open');
$vehicle_type_string = appendVehicleString($vehicle_type_string, $semitrailer_open);

my $low_bed_semitrailer = $q->param('low_bed_semitrailer');
$vehicle_type_string = appendVehicleString($vehicle_type_string, $low_bed_semitrailer);

my $semitrailer_coils = $q->param('semitrailer_coils');
$vehicle_type_string = appendVehicleString($vehicle_type_string, $semitrailer_coils);

my $adr_vehicle = $q->param('adr_vehicle');
$vehicle_type_string = appendVehicleString($vehicle_type_string, $adr_vehicle);

my $national_trans = $q->param('national_trans');
my $international_trans = $q->param('international_trans');

my $nat_tr;
my $int_tr;

if( $national_trans )
{
   $nat_tr = 1;
}
else
{
   $nat_tr = 0;
}

if( $international_trans )
{
   $int_tr = 1;
}
else
{
   $int_tr = 0;
}

$vehicle_type_string =~ s/^#//;

my $sid = $q->param('sid');
my $usession = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
# get token from session
my $token = $usession->param("token");
my $token_face1 = $usession->param("token_face1");

# guard from double insertion
if( $token_face1 ne $token)
{
    # redirect indicating that probably the account creation has been already aceived
    generateHTMLCompleteRegistration("Already registered", "Already registered");
}
else
{
    my $durc_file_inserted="False";
    if ( $filename )
    {
        $durc_file_inserted="True";
        my ( $name, $path, $extension ) = fileparse ( $filename, '..*' ); $filename = $name . $extension;
        $filename =~ tr/ /_/; $filename =~ s/[^$safe_filename_characters]//g;
        if ( $filename =~ /^([$safe_filename_characters]+)$/ ) { $filename = $1; } else { die "Filename contains invalid characters"; }
        my $upload_filehandle = $q->upload("files");
        open ( UPLOADFILE, ">$upload_dir/$filename" ) or die "$!"; binmode UPLOADFILE;

        while ( <$upload_filehandle> )
         {
         print UPLOADFILE;
         }

        close UPLOADFILE;
    }

    my $timestamp=generatePGTimestamp();

    # connect to database
    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();

    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
      or die $DBI::errstr;

    # escape the referer
    $referer= $dbh->quote( $referer );

    # escape the company name
    $company= $dbh->quote( $company );

    # escape the address
    $address= $dbh->quote( $address );

    # escape the register_code
    $register_code= $dbh->quote( $register_code );

    # escape also phone numbers
    $phone  = $dbh->quote($phone);
    $mobile = $dbh->quote($mobile);
    #$uemail = $dbh->quote($uemail);
    $vat_number = $dbh->quote($vat_number);
    #$username = $dbh->quote($username);
    #$password = $dbh->quote($password);
    # remove leading and right whitespaces from username
    $username =~ s/^\s+|\s+$//g;
    # remove leading and right whitespaces from password
    $password =~ s/^\s+|\s+$//g;

    # make sure that the username provided is available

    my $PG_COMMAND="insert into users3(username, password, email, company_name, vat_number, phone, mobile, referer, address, creation_time, register_code, vehicle_type, national, international, enabled, region, province, privacy, conditions) values(E\'$username\', E\'$password\', E\'$uemail\', $company, $vat_number, $phone, $mobile, $referer, $address, TIMESTAMP WITH TIME ZONE \'$timestamp\-07\', $register_code, \'$vehicle_type_string\', \'$nat_tr\', \'$int_tr\', \'1\', \'$region_str\', \'$province_str\', \'1\', \'1\') RETURNING id";

    my $sth = $dbh->prepare($PG_COMMAND)
       or die "Couldn't prepare statement: " . $dbh->errstr;

# check the existance of the email
my $email_exists = email($uemail);
my $password_exists = password($password, $password_c);

if( $email_exists and $password_exists )
{
    my $retval = $sth->execute( );
    if(!$retval)
    {
      # save to logfile
      my $path = "/home2/cargoevo";
      my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
      $year += 1900;
      $mon++;
      my $currdate = "$mon$mday$year";

      my $logfile = $path . "/$currdate.log";
      open (OUT, ">>$logfile");
      print OUT "inser_user.pl: SQL $PG_COMMAND\n\n $dbh->errstr \n";
      close(OUT);
      die "Cannot insert user, $timestamp";
    }
}
else
{
    die "Check parameters $email_exists || $password_exists";
}


    # get the newly generated ID, got with the RETURNING statement
    my @row= $sth->fetchrow_array;
    my $uid;
    if( (scalar @row) != 0 )
    {
       $uid = $row[0];
    }
    else
    {
       $uid = 0;
       exit;
    }
    # save user ID into the session so it is not necessary to pass the UserID
    $usession->param("username", $uid);

    # generate temporary HTML page to complete the registration
    my $html_link = generateTempHTMLpageForRegistrationCompleted( $sid );
    my ($name, $path, $suffix) = fileparse($html_link);

    # insert the event in the account events table
    $PG_COMMAND="insert into account_events(uid, type, creation_time, html_link) values(\'$uid\', \'0\', TIMESTAMP WITH TIME ZONE \'$timestamp\-07\', \'$html_link\')";
    my $sth = $dbh->prepare($PG_COMMAND)
       or die "Couldn't prepare statement events: " . $dbh->errstr;

    $sth->execute( )
          or die "Can't execute SQL statement, events: $dbh::errstr\n";

    if( $durc_file_inserted eq "True" )
    {
       my $fn="$upload_dir/$filename";
       #insert the file into the durc database
       $PG_COMMAND="insert into durc(uid, pdf, creation_time, filename) values(\'$uid\', ?, TIMESTAMP WITH TIME ZONE \'$timestamp\-07\', \'$filename\')";
       my $sth = $dbh->prepare($PG_COMMAND)
          or die "Couldn't prepare statement for DURC insertion: " . $dbh->errstr;

       my $filedata = read_file_bin($fn);
          $sth->bind_param(1, $filedata, { pg_type => DBD::Pg::PG_BYTEA });

       $sth->execute( )
          or die "Can't execute SQL statement for DURC insertion: $dbh::errstr\n";

       undef $filedata;
    }
    # auto select all the regions for the user
    for (my $i=1; $i <= 20; $i++) {
      my $current_region = getRegionIT($i);
      my $PG_COMMAND1  = "insert into regions(uid, region) values(?, ?)";
      my $sth3 = $dbh->prepare($PG_COMMAND1)
        or die "Can't execute SQL statement INSERT regions: $dbh::errstr\n";
      $sth3->execute( $uid, $current_region )
        or die "Can't execute SQL statement INSERT regions: $dbh::errstr\n";
      $sth3->finish;
    }

    # send an email to the user that the registration is completed and that it needs to be activated
    my $email = getEmailFromUserID( $uid );
    my $subject="Completa la registrazione a cargoevolution";
    my $linkm="www.cargoevolution.com/tmp/$name?sid=$sid";
    my $mailBody="Ci sei quasi, adesso devi solo attivare l\'account.\n.Clicca il seguente link per completare la registrazione:\n\n$linkm\n\nSe il browser non ti reindirizza alla pagina corretta copia ed incolla\n il link nella barra degli indirizzi del tuo browser preferito.\n\nLo staff di cargoevolution\n";
    sendEmailFunct($email, $subject, $mailBody);

    $sth->finish;
    $dbh->disconnect();

    my $new_token= rand(10000000);
    $usession->param("token_face1", "$new_token");

    $token = $usession->param("token");
    $token_face1 = $usession->param("token_face1");

    generateHTMLCompleteRegistration();

}
