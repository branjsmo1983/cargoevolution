#!/usr/bin/perl

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
require "../cgi-bin/getAdminHash.pl";
require "../cgi-bin/getLastDURCFromUserID.pl";
require "../cgi-bin/checkDurcExistence.pl";
require "../cgi-bin/getRegionsFromUserID.pl";

print header (-charset => 'UTF-8');
my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

my $q = CGI->new();
my $sid = $q->param('sid');

my $usession = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $uid = $usession->param('username');
my $user_valid = validateUserID($uid, $sid  );

if( $user_valid eq "False" )
{
  exit;
}

if ( getAdminHash() eq $uid or "2cff49e7376ab1b303b40e5e66c3795a" eq  $uid or "23f83ef1ed40e8cf5e7184591640e4aa" eq $uid )
{

}
else
{
  print "Forbidden!";
  exit;
}

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
   or die $DBI::errstr;

my $PG_COMMAND="select username, email, company_name, enabled, creation_time, time_last_action, vehicle_type, vat_number, phone, mobile, referer, id, register_code, feedback from users3 order by time_last_action DESC";
my $sth = $dbh->prepare($PG_COMMAND)
    or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute()
    or die "Couldn't execute statement: " . $dbh->errstr;

my $additional_flags = "<script type=\"text/javascript\" src=\"/setDocsStatus.js\"></script>";
generateHTMLheader("List of Users page");
my $cnt = 1;

my @row;
while(@row = $sth->fetchrow_array){
	my $username = $row[0];
  my $email = $row[1];
  my $company_name = $row[2];
  my $status = $row[3];
  my $creation_time = $row[4];
  my $time_of_last_action = $row[5];
  my $vehicle_type = $row[6];
  my $vat_number = $row[7];
  my $phone = $row[8];
  my $mobile = $row[9];
  my $referer = $row[10];
  my $uid = $row[11];
  my $register_code = $row[12];
  my $feedback = $row[13];
  print "<p>$cnt) username = $username, E-mail = $email, Referente = $referer , enabled = $status, creation = $creation_time, last_action = $time_of_last_action, VT: $vehicle_type, P.IVA:  $vat_number, phone: $phone, mobile: $mobile, feedback: $feedback\n";
  # $register_code
  print "<p>Albo trasportatori: $register_code</p>";
my $filename="tmp$username$company_name";
# remove whitespaces
$filename =~ s/\s//g;
# remove tabs
$filename =~ s/\t//g;
# remove carrige
$filename =~ s/\r//g;
# remove special characters
$filename =~ s/\W//g;
$filename = "$filename.pdf";
# my $result = getLastDURCFromUserID( $uid, $filename );
my $result;

print "<form action=\"/cgi-bin/insertDurc.pl\" method=\"post\" accept-charset=\"utf-8\" enctype=\"multipart/form-data\">\n";
print "<input type=\"hidden\" name=\"demail\" id=\"demail\" value=\"$email\" />";
print "<input type=\"hidden\" name=\"sid\" id=\"sid\" value=\"$sid\" />";
print "<input type=\"file\" id=\"files\" name=\"files\" /> DURC (carica un file pdf)\n";
print "<output id=\"list\"></output>";
print "<input type=\"submit\" value=\"Inserisci DURC\"/>";
print "</form>\n";

my $res_d = checkDurcExistence( $uid );
if ( $res_d eq "True" )
{
  print "<div data-role=\"content\">\n";
  print  "<button onclick=\"getDurc(\'$uid\', \'$filename\')\">Ultimo DURC</button> </div>";
}

if( $result )
{
  print "<a href=/tmp/$filename> Ultimo DURC </a>";
}
else
{
  print "<div id=\"last_durc\" name=\"last_durc\"></div>";
}
print <<EOF;
  </hr></p>
EOF
# add the possibility to signal a problem with the docs uploaded
print "<div data-role=\"content\">\n";
print  "<button onclick=\"setDocsStatus(\'$uid\', 1)\">Doc. OK</button> </div>";
print "<div data-role=\"content\">\n";
print  "<button onclick=\"setDocsStatus(\'$uid\', 0)\">Doc. KO</button> </div>";

# user regions
my @regions = getRegionsFromUserID($uid);
print "<div>\n";

print "<p>Regioni: ";
while( my $reg = pop @regions )
{
  print "$reg, ";
}
print "</p>";

print "<hr/></div>\n";
$cnt = $cnt + 1;
}
# generate javascript to  get the last durc
print '<script>
function getDurc(uid, filename){

    args = "?uid=" + uid + "&filename=" + filename;
    // alert ("uid = " + uid  + " filename = " +  filename);

    $.ajax({
        type: \'POST\',
        url: \'/cgi-bin/displayDurc.pl\'+ args,
        data: {  \'uid\' : uid, \'filename\' : filename},
        success: function(res) {
        // alert("DURC: " + "/tmp/" + res);
        window.open( "/tmp/" + res , \'_blank\');
           return false;
        },
        error: function( res) { alert("Error"  + res);}
    });
}
</script>';
print  "$additional_flags </body></html>";



$sth->finish;
$dbh->disconnect();
