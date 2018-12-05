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
require "../cgi-bin/getAdminHash.pl";

sub generateHTMLInputFormAdmin{

my $form_type=$_[0];
my $SID_from_calling_function = $_[1];
my $sessionID;
my $from_login_arg=$_[2];
my $cgi_script;
my $button_string;
my $title;

my $q = CGI->new();
my $userID_from_CGI;
my $from_login;
my $from_edit = $_[24];
my $arg_mid = $_[25];

if( $SID_from_calling_function and $form_type ne "insert" )
{
   $sessionID = $SID_from_calling_function;
}
else
{
   # get the ID from CGI
   $sessionID = $q->param('sid');
   $from_login = "False";
}

#get the username from the user session
my $session;

  # print "\$sessionID = $sessionID\n";
$session = new CGI::Session(undef, $sessionID, {Directory=>"/tmp"});
$userID_from_CGI = $session->param("username");
my $uid = $userID_from_CGI;
$session->param("from_admin", "True");

if ( getAdminHash() eq $uid or "2cff49e7376ab1b303b40e5e66c3795a" eq  $uid or "23f83ef1ed40e8cf5e7184591640e4aa" eq $uid )
{

}
else
{
  print "Forbidden!";
  exit;
}



# generate a random number to lock the refresh button
my $token= rand(10000000);
#print "\$token\n$token";
# save the token  into the user session
$session->param("token", "$token");
$session->param("token_face1", "$token");

if( $from_login_arg and $form_type ne "insert" )
{
   $from_login = "True";
}
else
{
   $from_login = "False";
}

my $is_user_valid =validateUserID( $userID_from_CGI, $sessionID );

if( $is_user_valid  eq "False")
{
   generateErrorPage("Invalid User");
   exit;
}

my $require_date_of_loading;

if( $form_type eq "insert" )
{
   if( "$from_edit" eq "from_create" )
   {
      $cgi_script = "input.pl";
      $button_string = "Crea";
      $title = "Crea nuovo trasporto";
      $require_date_of_loading = "required";
   }
   elsif ("$from_edit" eq "from_edit" )
   {
      $cgi_script = "edit.pl";
      $button_string = "Modifica";
      $title = "Modifica Trasporto esistente";
      $require_date_of_loading = "required";
   }
   else
   {
      $cgi_script = "input.pl";
      $button_string = "Inserisci";
      $title = "Inserisci un annuncio";
      $require_date_of_loading = "required";
   }
}
else
{
   $cgi_script = "select.pl";
   $button_string = "Cerca";
   $title = "Cerca negli annunci";
   $require_date_of_loading = "";
}

# detect if the form is a re-issue for the correction of missing, inconsistent data
my $message_type=$_[1];
my $MT=$_[2];
my $date_of_loading1=$_[3];
my $DL1=$_[4];
my $date_of_loading2=$_[5];
my $DL2=$_[6];
my $pick_up_region=$_[7];
my $PUR=$_[8];
my $pick_up_province=$_[9];
my $PUP=$_[10];
my $delivery_region=$_[11];
my $DR=$_[12];
my $delivery_province=$_[13];
my $PUR=$_[14];
my $veihcle_type=$_[15];
my $VT=$_[16];
my $arg_status=$_[17];
my $arg_length=$_[18];
my $arg_weight=$_[19];
my $arg_notes=$_[20];
my $arg_bay_for_coils = $_[21];
my $arg_adr = $_[22];
my $arg_big_volume = $_[23];


my $message_to_the_user;

if( ($message_type or $MT eq "Fahiddelse") and ( $form_type eq "insert" ) )
{
   if( "$from_edit" eq "from_create" )
   {
      $title = "Crea nuovo trasporto";
   }
   elsif ("$from_edit" eq "from_edit" )
   {
      $title = "Modifica trasporto esistente";
   }
   else
   {
      $title = "Completa i campi <mark>evidenziati</mark>";
      $message_to_the_user = "Trasporto non salvato.";
   }
}
else
{
   $message_to_the_user = "";
}

if(  $from_login eq "False" )
{
	print <<EOF;
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 5.0 Final//IT" >
EOF

	my $addtional_tags;
	my $IT_month_names = "monthNames: [ \"Gennaio\", \"Febbraio\", \"Marzo\", \"Aprile\", \"Maggio\", \"Giugno\", \"Luglio\", \"Agosto\", \"Sttembre\", \"Ottobre\", \"Novembre\", \"Dicembre\" ]";

	my $timestamp = generatePGTimestamp();

    # get today's numberla date
    my @tmp = split(" ", $timestamp);
    my $today = $tmp[0];
    $today = american2EuropeanData( $today );

	my $min_date = "minDate: $today";
	$addtional_tags = "$addtional_tags<script type=\"text/javascript\" src=\"/delivery_region.js\">\n</script>\n";
	$addtional_tags = "$addtional_tags<script type=\"text/javascript\" src=\"/pick_up_region.js\">\n</script>\n";
	$addtional_tags = "$addtional_tags<script type=\"text/javascript\" src=\"/map_handling.js\">\n</script>\n";
	$addtional_tags = "$addtional_tags<link rel=\"stylesheet\" href=\"/css/jquery-ui.css\">\n";
	$addtional_tags = "$addtional_tags<script src=\"/jquery-1.12.4.js\"></script>\n";
	$addtional_tags = "$addtional_tags<script src=\"/jquery-ui.js\"></script>\n";
	$addtional_tags = "$addtional_tags<script>\n\$( function() {\n\$( \"#date_of_loading1\" ).datepicker({ dateFormat: \"dd/mm/yy\" , dayNames: [ \"Domenica\", \"Lunedi\", \"Martedi\", \"Mercoledi\", \"Giovedi\", \"Venerdi\", \"Sabato\"], dayNamesMin: [ \"Do\", \"Lu\", \"Ma\", \"Me\", \"Gi\", \"Ve\", \"Sa\" ], $IT_month_names, $min_date, firstDay: 1 });\n} );\n</script>\n";
	$addtional_tags = "$addtional_tags<script>\n\$( function() {\n\$( \"#date_of_loading2\" ).datepicker({ dateFormat: \"dd/mm/yy\" , dayNames: [ \"Domenica\", \"Lunedi\", \"Martedi\", \"Mercoledi\", \"Giovedi\", \"Venerdi\", \"Sabato\"], dayNamesMin: [ \"Do\", \"Lu\", \"Ma\", \"Me\", \"Gi\", \"Ve\", \"Sa\" ], $IT_month_names, $min_date, firstDay: 1 });\n} );\n</script>\n";
print <<EOF;

<style type="text/css">
.ui-datepicker-title {
  text-align: center;
  color: black;
}
</style>

EOF
	generateHTMLopenTag();
	generateHTMLheader("Cargoevolution", $addtional_tags);
	print "<body>\n";
}
# print <<EOF;
# <div id="inputContent" class="container">
# EOF

print "<header>\n<h1>$title<\/h1>\n";
print "<p>$message_to_the_user</p>\n</header>\n";
generateHTMLUserActionLinks( $sessionID );

print <<EOF;
<guidance>
<p>

</p>
<div hidden>
<img alt="Seleziona la regione di consegna" src="../images/italia.gif"
     width="220" height="235" border="1" usemap="#regioni" />
EOF
# generate the map of italy
#my $cgi = CGI->new;

if( $from_login eq "False" )
{
   italia( $userID_from_CGI );
}
else
{
   italia( $userID_from_CGI, "from_log_in" );
}


print "</div>\n</guidance>\n";

print "<article>\n";
print "<form action=\"/cgi-bin/$cgi_script\" method=\"post\" accept-charset=\"utf-8\" enctype=\"multipart/form-data\">\n";
print "<fieldset>\n";
print "<input type=\"hidden\" id=\"third\" name=\"third\" value=\"third\">\n";
# retreive the user nickname to be displyed on the page
my $name_str = getUsernameFromUserID( $userID_from_CGI );

# , <a href=\"/cgi-bin/selectUserMessages.pl?username=$userID_from_CGI\">Clicca qui per consultare i tuoi annunci</a>
print "<p>Ciao Admin, inserisci un viaggio per conto terzi:  <input id=\"sid\" name=\"sid\" type=\"hidden\" value=\"";

my $username = $userID_from_CGI;
print "$sessionID\" />\n</p>";

my $mark_MT_open;
my $mark_MT_close;

if( $MT eq "True" or $form_type ne "insert" or !$MT )
{
   $mark_MT_open="";
   $mark_MT_close="";
}
else
{
   $mark_MT_open="<mark>";
   $mark_MT_close="</mark>";
}

# print "<p><select name=\"message_type\">\n";
# print "<option value=\"0\">Qualsiasi</option>\n";
# print "<option value=\"1\">Cerco Merce</option\n>";
# print "<option value=\"2\" selected>Offro Merce</option>\n</select>\n</p>\n";

print "<input type=\"hidden\" id=\"message_type\" name=\"message_type\" value=\"2\" />\n";
# save the token in the HTML, to be passed from CGI
print "<input type=\"hidden\" id=\"token\" name=\"token\" value=\"$token\" />\n";
print "<p>Email: <input type=\"email\" id=\"demail\" name=\"demail\" /></p>\n";
print "<p>\nData Carico:&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp <input type=\"text\"  data-polyfill=\"all\" id=\"date_of_loading1\" name=\"date_of_loading1\" placeholder=\"dd/mm/yyyy\" value=\"$date_of_loading1\" size=\"10\" $require_date_of_loading />\n</p>";
print "<p>\nData Carico Alt.: <input type=\"text\" data-polyfill=\"all\" id=\"date_of_loading2\" name=\"date_of_loading2\" placeholder=\"dd/mm/yyyy\" value=\"$date_of_loading2\" size=\"10\" />\n</p>";


my $mark_PUR_open;
my $mark_PUR_close;

if( $PUR or $form_type ne "insert" or !$MT )
{
   $mark_PUR_open="";
   $mark_PUR_close="";
}
else
{
   $mark_PUR_open="<mark>";
   $mark_PUR_close="</mark>";
}

print "<div>\n$mark_PUR_open Regione ritiro:&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp $mark_PUR_close\n";
print "<input type=\"hidden\" name=\"form_type2\" id=\"form_type2\" value=\"$form_type\"/> \n";
generateHTMLSelectorRegionIT( "pick_up_region", $pick_up_region );

print "<div id=\"pickUpRegionDiv\">\n<div>\n";

	if( $pick_up_province )
	{
	   print "<p>\nProvincia Ritiro:";
	}
	else
	{
	   print "<p hidden>\nProvincia Ritiro:";
	}

if( $form_type eq "insert" )
{
  generateHTMLSelectorProvinceIT( $pick_up_region, "pick_up_province", $pick_up_province );
}
else
{
  generateHTMLSelectorProvinceIT( $pick_up_region, "pick_up_province", $pick_up_province, "from_select" );
}
print <<EOF;
	</p>
	</div>
   </div>
   </div>
   <div>
EOF

my $mark_DR_open;
my $mark_DR_close;

if( $DR or $form_type ne "insert" or !$MT )
{
   $mark_DR_open="";
   $mark_DR_close="";
}
else
{
   $mark_DR_open="<mark>";
   $mark_DR_close="</mark>";
}

print "$mark_DR_open Regione consegna: $mark_DR_close";

   generateHTMLSelectorRegionIT( "delivery_region", $delivery_region );
print <<EOF;
   <div id="deliveryRegionDiv">
   <div>
EOF
	if( $delivery_province )
	{
	   print "<p>\nProvincia Consegna:";
	}
	else
	{
	   print "<p hidden>\nProvincia Consegna:";
	}

  if( $form_type eq "insert" )
  {
    generateHTMLSelectorProvinceIT( $delivery_region, "delivery_province", $delivery_province );
  }
  else
  {
    generateHTMLSelectorProvinceIT( $delivery_region, "delivery_province", $delivery_province, "from_select" );
  }

	print "</p>\n";

print <<EOF;
	</div>
   </div>
   </div>
EOF

my $require_dim;

if( $form_type eq "insert" )
{
   $require_dim = " required=\"required\" ";
   print "<p>\n";

   #utf8::decode( $arg_notes );
   #utf8::decode( $arg_notes );
   #utf8::upgrade( $arg_notes );

   print "Note: <textarea maxlength=\"120\" name=\"NotesArea\" id=\"NotesArea\" cols=\"40\" rows=\"3\" placeholder=\"Inserisci dei dettagli,\nIndirizzo ritiro\nIndirizzo consegna ..(max 120 caratteri)\" >$arg_notes</textarea>\n";
   print "</p>\n";
}
else
{
 $require_dim="";
}

print "<p>\n";
my $mark_VT_open;
my $mark_VT_close;

if( $VT or $form_type ne "insert" or !$MT )
{
   $mark_VT_open="";
   $mark_VT_close="";
}
else
{
   $mark_VT_open="<mark>";
   $mark_VT_close="</mark>";
}

print "$mark_VT_open Tipo veicolo $mark_VT_close: <select name=\"veihcle_type\" id=\"veihcle_type\">\n";
for(my $i=0; $i <= 7; $i=$i+1)
{
   my $Vstring=getVeihcleType( $i );

   if( $i == $veihcle_type)
   {
      print "<option value=\"$i\" selected>$Vstring</option>\n";
   }
   else
   {
     print "<option value=\"$i\">$Vstring</option>\n";
   }
}

print "</select>\n</p>\n";
# set vehicle details
if( $form_type eq "insert" )
{
    print "<p>\n";
    print "Metri di pianale: <input type=\"number\" id=\"v_length\" name=\"v_length\" $require_dim  min=0.1 max=13.6 step=\"0.1\" value=\"$arg_length\" />\n";
    print "</p>\n";
    print "<p>\n";
    print "Peso [t]:&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp <input type=\"number\" id=\"v_weight\" name=\"v_weight\" $require_dim min=0.1 max=31.0 step=\"0.1\" value=\"$arg_weight\" />\n";
    print "</p>\n";
}
else
{
   # allow the user to filter on the size length
   if( !$arg_length )
   {
     $arg_length = 13.6;
   }

   if( !$arg_weight )
   {
      $arg_weight = 31.0;
   }

   print "<p>\n";
   print "Metri di pianale: <input type=\"range\" onchange=\"updateTextInput(this.value);\" id=\"v_length\" name=\"v_length\" $require_dim  min=0.1 max=13.6 step=\"0.1\" value=\"$arg_length\" />\n<input id=\"textInput\" type=\"text\" readonly disabled size=\"3\" value=\"13.6\" ></input>[m]";
   print "</p>\n";

   print "<p>\n";
   print "Peso Trasportato: <input type=\"range\" value=\"31.0\" onchange=\"updateTextInput2(this.value);\" id=\"v_weight\" name=\"v_weight\" $require_dim  min=0.1 max=31.0 step=\"0.1\" value=\"$arg_weight\" />\n<input id=\"textInput2\" type=\"text\" readonly disabled size=\"3\" value=\"31.0\" ></input>[t]";
   print "</p>\n";
}

my $checked_adr;
if( $arg_adr eq "1" )
{
   $checked_adr = "checked";
}

my $checked_bay_for_coils;
if( $arg_bay_for_coils eq "1" )
{
   $checked_bay_for_coils = "checked";
}

my $checked_big_volume;
if( $arg_big_volume eq "1" )
{
   $checked_big_volume = "checked";
}

# get userID from email
#my $duid = getUserIDfromEmail();

if( $form_type eq "insert" )
{
print "<p>\n";
print "<input type=\"checkbox\" name=\"coils\" id=\"coils\" value=\"coils\" $checked_bay_for_coils />Buca Coils\n";
print "</p>\n";
print "<p>\n";
print "<input type=\"checkbox\" name=\"big_volume\" id=\"big_volume\" value=\"big_volume\" $checked_big_volume />Ribassato\n";
print "</p>\n";
print "<p>\n";

print "<input type=\"checkbox\" name=\"adr\" id=\"adr\" value=\"adr\" $checked_adr /> Trasporto ADR\n";
print "</p>\n";
print "<p>\n<input type=\"hidden\" name=\"arg_mid\" id=\"arg_mid\" value=\"$arg_mid\"  />\n</p>\n";
}
#print "<p>\$form_type = $form_type</p>";
print <<EOF;
   <p>
   <input type="submit" value="$button_string"/>
   </p>
</fieldset>
</form>
</article>
EOF

generateHTMLFooter();
print <<EOF;
<script>
function updateTextInput(val) {
          document.getElementById('textInput').value=val;
        }
function updateTextInput2(val) {
          document.getElementById('textInput2').value=val;
        }
</script>
EOF
if(  $from_login eq "False" )
{
   print "</body>\n";
   print "</html>\n";
}
else
{
   #print "<message> Questo funziona </message>\n";
}

}
1;
