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
use Digest::MD5;
use Encode;

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
require "../cgi-bin/generateHTMLActionPage.pl";
require "../cgi-bin/getRegionIT.pl";
require "../cgi-bin/getProvinceIT.pl";

# print header (-charset => 'UTF-8');
my $q = CGI->new();
$q::POST_MAX = 1024 * 5000;
my $safe_filename_characters = "a-zA-Z0-9_.-";
my $upload_dir = "/home2/cargoevo/public_html/tmp";

my $username = $q->param('username');
my $password = $q->param('password');
my $password_c = $q->param('password_c');
my $uemail = $q->param('uemail');
my $skype = $q->param('skype');
my $company = $q->param('company');
my $vat_number = $q->param('vat_number');
my $phone = $q->param('phone');
my $mobile = $q->param('mobile');
my $referer = $q->param('referer');
my $address = $q->param('address');
my $register_code = $q->param('register');
my $filename = $q->param('files');
# get vehicle configuration
my $vehicle_type_string;
my $region = $q->param('sel_reg');
my $province = $q->param('sel_prov');
# ge strings
my $region_str = getRegionIT( $region );
my $province_str = getProvinceIT( $region, $province );

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

$vehicle_type_string =~ s/^#//;

my $sid = $q->param('sid');
my $usession = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
# get user ID from user session
my $uid = $usession->param('username');
validateUserID( $uid, $sid );

# get token from session
my $token = $usession->param("token");
my $token_face1 = $usession->param("token_face1");

# guard from double insertion
if( $token_face1 ne $token)
{
    # redirect indicating that probably the account creation has been already aceived
    generateHTMLopenTag();
    generateHTMLheader("Operation completed");
    generateHTMLActionPage( "view", $sid, "from_redirection" );
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

    # make sure that the username provided is available
    # remove leading and right whitespaces from username
    $username =~ s/^\s+|\s+$//g;
    # remove leading and right whitespaces from password
    $password =~ s/^\s+|\s+$//g;

    my $PG_COMMAND="update  users3 set username=\'$username\', password=\'$password\', email=\'$uemail\', company_name=$company, vat_number=\'$vat_number\', phone=\'$phone\', mobile=\'$mobile\', referer=$referer, address=$address, register_code=$register_code, skype_name=\'$skype\', vehicle_type=\'$vehicle_type_string\', region=\'$region_str\', province=\'$province_str\' where id=?";


    my $sth = $dbh->prepare($PG_COMMAND)
       or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute( $uid )
          or die "Can't execute SQL statement: $dbh::errstr\n";

    # save user ID into the session so it is not necessary to pass the UserID
    $usession->param("username", $uid);

    # generate temporary HTML page to complete the registration
    my $html_link = "/index.html";

    # insert the event in the account events table
    $PG_COMMAND="insert into account_events(uid, type, creation_time, html_link) values(\'$uid\', \'1\', TIMESTAMP WITH TIME ZONE \'$timestamp\-07\', \'$html_link\')";
    my $sth = $dbh->prepare($PG_COMMAND)
       or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute( )
          or die "Can't execute SQL statement: $dbh::errstr\n";

    $sth->finish;

    if( $durc_file_inserted eq "True" )
    {
       my $fn="$upload_dir/$filename";
       #insert the file into the durc database
       $PG_COMMAND="insert into durc(uid, pdf, creation_time) values(\'$uid\', ?, TIMESTAMP WITH TIME ZONE \'$timestamp\-07\')";
       my $sth = $dbh->prepare($PG_COMMAND)
          or die "Couldn't prepare statement: " . $dbh->errstr;

       my $filedata = read_file_bin($fn);
          $sth->bind_param(1, ($filedata), { pg_type => DBD::Pg::PG_BYTEA });

       $sth->execute( )
          or die "Can't execute SQL statement: $dbh::errstr\n";

       undef $filedata;
    }


    # send an email to the user that the registration is completed and that it needs to be activated
    my $email = getEmailFromUserID( $uid );
    my $subject="Il tuo profilo è stato modificato cargoevolution.com";
    my $linkm="www.cargoevolution.com/login.html";
    my $mailBody="Il tuo profilo è stato modificato, se non hai effettuato cambiamenti contatta subito info\@cargoevolution.com\n";
    $sth->finish;
    $dbh->disconnect();

    sendEmailFunct($email, $subject, $mailBody);


    my $new_token= rand(10000000);
    $usession->param("token_face1", "$new_token");

    #generateHTMLopenTag();
    #generateHTMLheader("Operation completed");
    #generateHTMLActionPage( "view", $sid, "from_redirection" );

    # http://www.cargoevolution.com/cgi-bin/generateHTMLHome.pl?sid=
    print $q->redirect( "generateHTMLHome.pl?sid=$sid" );

}
