#!/usr/bin/perl

use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use Path::Class;
use strict;
use warnings;

use DBI;
use DBD::Pg;
use DBD::Pg qw(:pg_types);

require "../cgi-bin/italia.pl";
require "../cgi-bin/generateHTMLSelectorRegionIT.pl";
require "../cgi-bin/generateHTMLSelectorProvinceIT.pl";
require "../cgi-bin/getUsernameFromUserID.pl";
require "../cgi-bin/generateHTMLheader.pl";
require "../cgi-bin/generateHTMLopenTag.pl";
require "../cgi-bin/generateHTMLFooter.pl";
require "../cgi-bin/getVeihcleType.pl";
require "../cgi-bin/validateUserID.pl";
require "../cgi-bin/generateErrorPage.pl";
require "../cgi-bin/generateHTMLUserActionLinks.pl";
require "../cgi-bin/generatePGTimestamp.pl";
require "../cgi-bin/american2EuropeanData.pl";
require "../cgi-bin/getAdminHash.pl";
require "../cgi-bin/getLastDURCFromUserID.pl";
require "../cgi-bin/checkDurcExistence.pl";
require "../cgi-bin/getRegionNum.pl";
require "../cgi-bin/getProvinceNum.pl";
require "../cgi-bin/checkDurcExistenceTime.pl";
require "../cgi-bin/convertPGtimestamp2EurDateTime.pl";
require "../cgi-bin/generateHTMLRegionsIT.pl";

print header (-charset => 'UTF-8');

my $q = CGI->new();
my $sid = $q->param('sid');

#print "\$sid: $sid\n";

my $usession = new CGI::Session(undef, $sid, {Directory=>"/tmp"});

# get userID and validate the user
my $uid = $usession->param('username');

#print "\$uid: $uid\n";

validateUserID( $uid, $sid );

# generate the token and save it into the session
my $token= rand(10000000);
$usession->param("token", "$token");
$usession->param("token_face1", "$token");

# retrieve data fromdatabase
my $PG_COMMAND="select * from users3 where id=?";

# connect to database
my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
   or die $DBI::errstr;

my $sth = $dbh->prepare($PG_COMMAND)
   or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute( $uid )
      or die "Can't execute SQL statement: $dbh::errstr\n";

my @row = $sth->fetchrow;

$sth->finish;
$dbh->disconnect();

print <<EOF;
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 5.0 Final//IT" >
EOF

my $addtional_tags="<script type=\"text/javascript\" src=\"/blacklist_search.js\"></script>\n";
$addtional_tags="$addtional_tags<script type=\"text/javascript\" src=\"/region_combo.js\"></script>\n";
$addtional_tags="$addtional_tags<script type=\"text/javascript\" src=\"/blacklist_refresh.js\"></script>\n";
#$addtional_tags="$addtional_tags<script type=\"text/javascript\" src=\"/mutex.js\"></script>\n";
#$addtional_tags="$addtional_tags<script type=\"text/javascript\" src=\"/jquery.maphilight.min.js\"></script>\n";

print <<EOF;

<style type="text/css">
.ui-datepicker-title {
  text-align: center;
  color: black;
}
</style>
EOF

my $cgi_script="updateUser.pl";
my $uid = $row[0];
my $username= $row[1];
my $password= $row[2];
my $vehicle_type_str= $row[3];
my $email= $row[4];
my $feedback= $row[5];
my $company_name=$row[6];
my $vat_number=$row[7];
my $phone=$row[8];
my $mobile=$row[9];
my $referer=$row[10];
my $address=$row[11];
my $num_vehicles=$row[12];
my $register_carriers=$row[14];
my $register_code=$row[17];
my $skype=$row[18];
my $region_str=$row[22];
my $province_str=$row[23];

# get region and province number
my $region = getRegionNum( $region_str );
my $province = getProvinceNum($region, $province_str);

if( $vehicle_type_str eq "Tutti" )
{
    $vehicle_type_str = "1#1#1#1#1#1#1#1#1#";
}

$vehicle_type_str =~ s/1/checked/g;
$vehicle_type_str =~ s/0/ /g;

#print "\$vehicle_type_str=$vehicle_type_str\n";

my @v_c = split("#", $vehicle_type_str);
my $c1= $v_c[0];
my $c2= $v_c[1];
my $c3= $v_c[2];
my $c4= $v_c[3];
my $c5= $v_c[4];
my $c6= $v_c[5];
my $c7= $v_c[6];
my $c8= $v_c[7];
my $c9= $v_c[8];


generateHTMLopenTag();
generateHTMLheader("Il tuo account", $addtional_tags);
print"<body>\n";
print "<header><h1>Visualizza o modifica i tuoi dati</h1><p><a class=\"btn btn-default btn-lg\" href=\"/privacy.pdf\" target=\"_blank\">Privacy</a></p><p><a class=\"btn btn-default btn-lg\" href=\"/condizioni.pdf\" target=\"_blank\">Condizioni</a></p></header>";
print "<article>\n";
print "<div class=\"row\">";
print "<p> <a href=\"javascript:history.back()\">>Torna indietro</a> </p>\n";
print "<div class=\"col-md-5  col-sm-6 col-xs-6\">\n";
print "<h2>Informazioni generali</h2>";
print "<form action=\"/cgi-bin/$cgi_script\" method=\"post\" accept-charset=\"utf-8\" enctype=\"multipart/form-data\">\n";
print "<p>\n";
print "Username: <input class=\"pull-right\" type=\"text\" required=\"required\" id=\"username\" name=\"username\" size=\"10\" VALUE=\"$username\" readonly > \n";
print "</p>\n";
print <<EOF;
<p>
Password: <input class=\"pull-right\" type=\"password\" required=\"required\"  id="password" name="password" size="10" VALUE=\"$password\" >
</p>
<p>
Conf. Pass.: <input class=\"pull-right\" type=\"password\" required=\"required\" id="password_c" name="password_c" size="10" value=\"$password\" >
</p>
<p>
E-mail: <input class=\"pull-right\" type="email" required="required" id="uemail" name="uemail" size="18" value=\"$email\" >
</p>
<p hidden>
Nome Skype: <input class=\"pull-right\" type="text" id="skype" name="skype" size="15" value=\"$skype\" >
</p>
<p>
Azienda: <input class=\"pull-right\" type="text"  required="required" id="company" name="company" size="15" value=\"$company_name\" >
</p>
<p>
P.IVA: <input class=\"pull-right\" type="text"  required="required" id="vat_number" name="vat_number" size="15" value=\"$vat_number\" >
</p>
<p>
Telefono: <input class=\"pull-right\" type="tel"  required="required" id="phone" name="phone" size="15" value=\"$phone\" >
</p>
<p>
Cellulare: <input class=\"pull-right\" type="tel"  required="required" id="mobile" name="mobile" size="15" value=\"$mobile\" >
</p>
<p>
Referente: <input class=\"pull-right\" type="text"  required="required" id="referer" name="referer" size="15" value=\"$referer\" >
</p>
<p>
Albo Trasportatori: <input class=\"pull-right\" type="text"  id="register" name="register" size="16" placeholder="Scrivi il numero di iscrizione" value=\"$register_code\">
</p>
<p>
Indirizzo sede operativa:
</p>
<div id="region_sel" name="region_sel" class="pull-right">
 <input  type="hidden" name="region"  id="region" value="$region">
 <input  type="hidden" name="province" id="province" value="$province">
</div>
<div id="province_sel" name="province_sel" class="pull-right">
</div>
<p>
<input  class=\"pull-right\" type="text"  required="required" id="address" name="address" size="20" placeholder="Sede operativa" value=\"$address\" >
</p>

EOF
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

print "</div>";
print "<div class=\"col-md-6  col-sm-6 col-xs-6\">\n";
print <<EOF;
<div>
<h2>Parco mezzi</h2>
</div>
<p>
Hai le seguenti tipologie di mezzo? (marca la casella in caso affermativo):
</p>
<p>
<input type="checkbox" name="tractor" id="tractor" $c1 /> Bilico Centinato
</p>
<p>
<input type="checkbox" name="tractor_lift" id="tractor_lift" $c2 /> Aperto
</p>
<p>
<input type="checkbox" name="trucks" id="trucks" $c3 /> Frigo
</p>
<p>
<input type="checkbox" name="semitrailer" id="semitrailer" $c4 /> Autotreno
</p>
<p>
<input type="checkbox" name="semitrailer_fridge" id="semitrailer_fridge" $c5 /> Sponda idraulica
</p>
<p>
<input type="checkbox" name="semitrailer_open" id="semitrailer_open" $c6 /> Motrice
</p>
<p>
<input type="checkbox" name="low_bed_semitrailer" id="low_bed_semitrailer" $c7 /> Aperto Ribassato
</p>
<p>
<input type="checkbox" name="semitrailer_coils" id="semitrailer_coils" $c8 /> Semirimorchio con Buca Coils
<img src="/images/buca_coils_ico.png" />
</p>
<p>
<input type="checkbox" name="adr_vehicle" id="adr_vehicle" $c9 /> ADR vehicle
<img src="/images/adr.png" />
</p>
<p>
<input type="submit" value="Applica"/>
</p>
<p>
<input type="hidden" name="sid" id="sid" value="$sid" />
</p>

<script>
  function handleFileSelect(evt) {
    var files = evt.target.files; // FileList object

    // files is a FileList of File objects. List some properties.
    var output = [];
    for (var i = 0, f; f = files[i]; i++) {
      output.push('<li><strong>', escape(f.name), '</strong> (', f.type || 'n/a', ') - ',
                  f.size, ' bytes, last modified: ',
                  f.lastModifiedDate ? f.lastModifiedDate.toLocaleDateString() : 'n/a',
                  '</li>');
    }
    document.getElementById('list').innerHTML = '<ul>' + output.join('') + '</ul>';
  }

  //document.getElementById('files').addEventListener('change', handleFileSelect, false);
</script>
EOF
#print "</fieldset>\n";
print "</form>\n<hr>\n";

my $res_d = checkDurcExistenceTime( $uid );

# retrieve date and time
my $euro_time = convertPGtimestamp2EurDateTime( $res_d );

if ( $res_d ne "False" )
{
  #print "<div data-role=\"content\">\n";
  print <<EOF;

  </div>
  </div>
  <div class="row">
  <div class="col-md-5  col-sm-6 col-xs-6">


  <div> <h2>Gestione DURC</h2>
  <form action="/cgi-bin/insertOwnDurc.pl" method="post" accept-charset="utf-8" enctype="multipart/form-data">
  <p><input type="hidden" name="demail" id="demail" value="$email" /></p>
  <p><input type="hidden" name="sid" id="sid" value="$sid" /></p>
  <p><input type="file" id="files" name="files" required /> DURC (carica un file pdf)</p>
  <output id="list"></output>
  <button type="submit"> Salva DURC </button>
  </form>
  </div>
EOF
  print "<p>Ultimo inserimento DURC: " . $euro_time . "</p>";
  print  "<button onclick=\"getDurc(\'$uid\', \'$filename\')\">Visualizza l'ultimo DURC</button>";
}
else
{
print "<p>Nessun DURC trovato</p>";
print <<EOF;
  </div>
  </div>
  <div class="row">
  <div class="col-md-5  col-sm-6 col-xs-6">


  <div> <h2>Gestione DURC</h2>
  <form action="/cgi-bin/insertOwnDurc.pl" method="post" accept-charset="utf-8" enctype="multipart/form-data">
  <p><input type="hidden" name="demail" id="demail" value="$email" /></p>
  <p><input type="hidden" name="sid" id="sid" value="$sid" /></p>
  <p><input type="file" id="files" name="files" required /> DURC (carica un file pdf)</p>
  <output id="list"></output>
  <button type="submit"> Salva DURC </button>
  </form>
  </div>
EOF
}

print "<hr><div id=\"blacklistUser\" name=\"blacklistUser\"> </div>\n";

print "<form method=\"\" action=\"\" name=\"BlackListForm\"  id=\"BlackListForm\" >\n";
print <<EOF;
<p>
<input type="text" id="key_value" name="key_value" size="22" placeholder="Cerca ragione sociale da bloccare" >
</p>
<p>
<input type="submit" value="Cerca"/>
</p>
EOF
print "</form>\n<hr>\n";
print "<div id=\"blacklistResults\" name=\"blacklistResults\"> </div>\n";
# if I am the admin show me also the admin tools
if ( getAdminHash() eq $uid or "2cff49e7376ab1b303b40e5e66c3795a" eq  $uid or "23f83ef1ed40e8cf5e7184591640e4aa" eq $uid )
{
  print "<p> <a href=\"/cgi-bin/prepareLastDurcFromUsers.pl?sid=$sid\"> Get DURC files </a> </p>";
  print "<p> <a href=\"/cgi-bin/esempioFeedDB.pl?sid=$sid\"> Compute average feedback </a> </p>";
  print "<p> <a href=\"/cgi-bin/listUsers.pl?sid=$sid\"> List Users </a> </p>";
  print "<p> <a href=\"/cgi-bin/listAccountEvents.pl?sid=$sid\"> Account Events </a> </p>";
  print "<p> <a href=\"/cgi-bin/manageVehicles.pl?sid=$sid\"> Manage trucks </a> </p>";
  print "<p> <a href=\"/cgi-bin/selectClosedBusiness.pl?sid=$sid\"> Business </a> </p>";
  print "<p> <a href=\"/cgi-bin/login_succAdmin.pl?sid=$sid\"> Insert trip </a> </p>";
  #print "<p> <a href=\"/cgi-bin/driver_tt.pl\"> Send email </a> </p>";
# <form>
# <!-- <input type="submit" name="de_mesg" id="de_mesg" value="Procedi"> -->
# </form>

}
print "</div>";
generateHTMLRegionsIT();
print "</article>\n";


generateHTMLFooter();

print <<EOF;
<script type="text/javascript" src="/regionMap.js" ></script>
<script type="text/javascript">

    var password = document.getElementById("password")
      , password_c = document.getElementById("password_c");

    function validatePassword(){
      if(password.value != password_c.value) {
        password_c.setCustomValidity("Le password non corrispondono");
      } else {
        password_c.setCustomValidity('');
      }
    }

    password.onchange = validatePassword;
    password_c.onkeyup = validatePassword;

</script>
EOF

print '<script>
function getDurc(uid, filename){

    args = "?uid=" + uid + "&filename=" + filename;
    //alert ("uid = " + uid  + " filename = " +  filename);

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


print"</body>\n</html>\n";
