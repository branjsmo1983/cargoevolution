#!/usr/bin/perl

use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use Path::Class;

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

# create a new session that expires after 1hour
my $usession = new CGI::Session("driver:File", undef, {Directory=>"/tmp"});
my $sid = $usession->id();
$usession->param("_logged_in", "1");
$usession->expire('_logged_in','1h');
# generate the token and save it into the session
my $token= rand(10000000);
#print "\$token\n$token";
# save the token  into the user session
$usession->param("token", "$token");
$usession->param("token_face1", "$token");

print header (-charset => 'UTF-8');
print <<EOF;
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 5.0 Final//IT" >
EOF

my $addtional_tags;
print <<EOF;

<style type="text/css">
.ui-datepicker-title {
  text-align: center;
  color: black;
}
</style>
EOF

my $cgi_script="insert_user.pl";

generateHTMLopenTag();
$addtional_tags = "$addtional_tags<script type=\"text/javascript\" src=\"/check_uname_avail.js\">\n</script>\n";
generateHTMLheader("Registrazione a cargoevolution", $addtional_tags);
print"<body>\n";
print "<header>Compila i tuoi dettagli</header>";
print "<article>\n";
print "<form action=\"/cgi-bin/$cgi_script\" method=\"post\" accept-charset=\"utf-8\" enctype=\"multipart/form-data\">\n";
print "<fieldset>\n";
print "<p>\n";
print "Username: <input type=\"text\" required=\"required\" id=\"username\" name=\"username\" size=\"10\" ></input>\n";
print "</p>\n";
print <<EOF;
<p>
Password: <input type=\"password\" required="required" id="password" name="password" size="10" ></input>
</p>
<p>
Conf. Pass.: <input type=\"password\" required="required" id="password_c" name="password_c" size="10" ></input>
</p>
<p>
E-mail: <input type="email" required="required" id="uemail" name="uemail" size="18" ></input>
</p>
<p>
Azienda: <input type="text"  required="required" id="company" name="company" size="15" ></input>
</p>
<p>
P.IVA: <input type="text"  required="required" id="vat_number" name="vat_number" size="15" ></input>
</p>
<p>
Telefono: <input type="tel"  required="required" id="phone" name="phone" size="15" ></input>
</p>
<p>
Cellulare: <input type="tel"  required="required" id="mobile" name="mobile" size="15" ></input>
</p>
<p>
Referente: <input type="text"  required="required" id="referer" name="referer" size="15" ></input>
</p>
<p>
Indirizzo: <input type="text"  required="required" id="address" name="address" size="20" placeholder="Sede operativa" ></input>
</p>
<p>
Albo Trasportatori: <input type="text"  id="register" name="register" size="20" placeholder="Scrivi il numero di iscrizione" ></input>
</p>
<p>
<input type="file" id="files" name="files" /> DURC (carica un file pdf)
<output id="list"></output>
</p>
<p>
<input type="checkbox" name="national_trans" id="national_trans" checked /> Trasporti nazionali
</p>
<p>
<input type="checkbox" name="international_trans" id="international_trans" checked /> Trasporti internazionali
</p>
<p>
Hai le seguenti tipologie di mezzo? (marca la casella in caso affermativo):
</p>
<p>
<input type="checkbox" name="tractor" id="tractor" checked /> Motrici
</p>
<p>
<input type="checkbox" name="tractor_lift" id="tractor_lift" /> Motrici con sponda
</p>
<p>
<input type="checkbox" name="trucks" id="trucks" /> Autotreni
</p>
<p>
<input type="checkbox" name="semitrailer" id="semitrailer" /> Semirimorchio Centinato
</p>
<p>
<input type="checkbox" name="semitrailer_fridge" id="semitrailer_fridge" /> Semirimorchio Frigo
</p>
<p>
<input type="checkbox" name="semitrailer_open" id="semitrailer_open" /> Semirimorchio Aperto
</p>
<p>
<input type="checkbox" name="low_bed_semitrailer" id="low_bed_semitrailer" /> Semirimorchio Ribassato
</p>
<p>
<input type="checkbox" name="semitrailer_coils" id="semitrailer_coils" /> Semirimorchio con Buca Coils
<img src="/images/buca_coils_ico.png" />
</p>
<p>
<input type="checkbox" name="adr_vehicle" id="adr_vehicle" /> ADR vehicle
<img src="/images/adr.png" />
</p>
<p>
<input type="submit" value="Registrati"/>
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

  document.getElementById('files').addEventListener('change', handleFileSelect, false);
</script>
EOF
print "</fieldset>\n";
print "</form>\n";
print "</article>\n";

generateHTMLFooter();

print <<EOF;
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

print"</body>\n<html>\n";

