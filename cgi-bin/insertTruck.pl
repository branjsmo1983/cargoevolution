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
require "../cgi-bin/generatePGTimestamp.pl";
require "../cgi-bin/american2EuropeanData.pl";
require "../cgi-bin/generateHTMLopenTag.pl";
require "../cgi-bin/getVeihcleType.pl";
require "../cgi-bin/generateHTMLSelectorRegionIT.pl";
require "../cgi-bin/getVeihcleType.pl";
require "../cgi-bin/getRegionIT.pl";
require "../cgi-bin/getEmailFromUserID.pl";

my $IT_month_names = "monthNames: [ \"Gennaio\", \"Febbraio\", \"Marzo\", \"Aprile\", \"Maggio\", \"Giugno\", \"Luglio\", \"Agosto\", \"Sttembre\", \"Ottobre\", \"Novembre\", \"Dicembre\" ]";
my $timestamp = generatePGTimestamp();

  # get today's numberla date
  my @tmp = split(" ", $timestamp);
  my $today = $tmp[0];
  $today = american2EuropeanData( $today );

my $min_date = "minDate: $today";
my $addtional_tags;
$addtional_tags = "$addtional_tags<script type=\"text/javascript\" src=\"/delivery_region.js\">\n</script>\n";
$addtional_tags = "$addtional_tags<script type=\"text/javascript\" src=\"/pick_up_region.js\">\n</script>\n";
$addtional_tags = "$addtional_tags<script type=\"text/javascript\" src=\"/map_handling.js\">\n</script>\n";
$addtional_tags = "$addtional_tags<link rel=\"stylesheet\" href=\"/css/jquery-ui.css\">\n";
$addtional_tags = "$addtional_tags<script src=\"/jquery-1.12.4.js\"></script>\n";
$addtional_tags = "$addtional_tags<script src=\"/jquery-ui.js\"></script>\n";
$addtional_tags = "$addtional_tags<script>\n\$( function() {\n\$( \"#date_of_loading1\" ).datepicker({ dateFormat: \"dd/mm/yy\" , dayNames: [ \"Domenica\", \"Lunedi\", \"Martedi\", \"Mercoledi\", \"Giovedi\", \"Venerdi\", \"Sabato\"], dayNamesMin: [ \"Do\", \"Lu\", \"Ma\", \"Me\", \"Gi\", \"Ve\", \"Sa\" ], $IT_month_names, $min_date, firstDay: 1 });\n} );\n</script>\n";
#$addtional_tags = "$addtional_tags<script>\n\$( function() {\n\$( \"#date_of_loading2\" ).datepicker({ dateFormat: \"dd/mm/yy\" , dayNames: [ \"Domenica\", \"Lunedi\", \"Martedi\", \"Mercoledi\", \"Giovedi\", \"Venerdi\", \"Sabato\"], dayNamesMin: [ \"Do\", \"Lu\", \"Ma\", \"Me\", \"Gi\", \"Ve\", \"Sa\" ], $IT_month_names, $min_date, firstDay: 1 });} );\n</script>\n";

print header (-charset => 'UTF-8');
generateHTMLopenTag();
generateHTMLheader("Inserisci Mezzo", $addtional_tags);

my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

my $q = CGI->new();
my $sid = $q->param('sid');

my $usession = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $uid = $usession->param('username');
my $userEmail = getEmailFromUserID($uid);
my $user_valid = validateUserID($uid, $sid  );

if( $user_valid eq "False" )
{
  exit;
}


print "<p> <a href=\"javascript:history.back()\">>Torna indietro</a> </p>\n";
print <<EOF;
<div class="panel panel-primary" style="margin:20px;">
<div class="panel-heading">
<h3 class="panel-title">Inserisci un mezzo</h3>
</div>
<div class="panel-body">
<form action="/cgi-bin/insertRedirectTruck.pl" method="post" accept-charset="utf-8" enctype="multipart/form-data">
<p>
<input type="hidden" name="sid" id="sid" value="$sid">
</p>
<p>
<label for="uemail">La mia mail = $userEmail</label>
<input type="hidden" id="uemail" name="uemail" placeholder="" value="$userEmail">
</p>
<p>
Data: <input type="text"  data-polyfill="all" id="date_of_loading1" name="date_of_loading1" placeholder="dd/mm/yyyy"  size="10" required /></p>
</p>
<p>
EOF

print "Tipo veicolo: <select name=\"veihcle_type\" id=\"veihcle_type\">\n";
for(my $i=0; $i <= 7; $i=$i+1)
{
   my $Vstring=getVeihcleType( $i );
   print "<option value=\"$i\">$Vstring</option>\n";
}
print "</select>\n</p><p>";
print "<label for=\"pick_up_region\">Regione Carico: </label>";
generateHTMLSelectorRegionIT( "pick_up_region" );

print "</p></select>\n</p><p>";
print "<label for=\"dregion\">Regione Consegna: </label>";
generateHTMLSelectorRegionIT( "dregion" );

print <<EOF;
</p>
<p>
<input type="submit" value="Aggiungi mezzo"/>
</p>
</form>
</div>
</div>
EOF

# Retieve data from Database
my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
   or die $DBI::errstr;

my $PG_COMMAND="select users3.email, trucks.day, trucks.vehicle_type, trucks.region, trucks.dregion, trucks.uid, trucks.id from trucks
  INNER JOIN users3 ON (users3.id = trucks.uid AND users3.id = '$uid') ORDER BY day DESC";
my $sth = $dbh->prepare($PG_COMMAND)
    or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute(  )
    or die "Couldn't execute statement: " . $dbh->errstr;


print <<EOF;
<div class="panel panel-primary" style="margin:20px;">
<div class="panel-heading">
<h3 class="panel-title">Mezzi inseriti</h3>
</div>
<div class="panel-body">
EOF

my $cnt = 1;

my @row;
while(@row = $sth->fetchrow_array){
  my $email = $row[0];
  my $day = $row[1];
  my $day1 = american2EuropeanData($day);
  my $vt = $row[2];
  my $region = $row[3];
  my $dregion = $row[4];
  my $user = $row[5];
  my $tid = $row[6];
  my $vname = getVeihcleType( $vt );
  my $region_str = getRegionIT( $region );
  my $dregion_str = getRegionIT( $dregion );

print <<EOF;
<div class="panel-heading">
<h4 class="panel-title">
<form action="/cgi-bin/deleteTruck.pl" method="post" accept-charset="utf-8" enctype="multipart/form-data">
<input type="hidden" name="sid" id="sid" value="$sid">
<input type="hidden" name ="uid" id="uid" value="$user">
<input type="hidden" name="day" id="day" value="$day">
<input type="hidden"  id="region" name="region" value="$region">
<input type="hidden" name="dregion" id="dregion" value="$dregion">
<input type="hidden"  id="vname" name="vname" value="$vt">
<input type="hidden"  id="tid" name="tid" value="$tid">
<a class="accordion-toggle" data-toggle="collapse" >$cnt) Data: $day1, Regione Carico: $region, Regione Consegna: $dregion, Tipologia Veicolo: $vname  </a>
<input type="submit" value="Rimuovi mezzo"/>
</form>
</h4>
</div>

EOF

  $cnt = $cnt + 1;
}



print <<EOF;
</div>
</div>
EOF

$sth->finish;

$PG_COMMAND="select trucks.uid, messages2.pick_up_region, messages2.pick_up_province, messages2.date_of_loading1, messages2.date_of_loading2, messages2.username, messages2.veihcle_type  from trucks INNER JOIN messages2 ON (pick_up_region = trucks.region and (delivery_region = trucks.dregion or trucks.dregion IS   NULL ) and (messages2.date_of_loading1 = trucks.day or  messages2.date_of_loading2 = trucks.day)) where messages2.veihcle_type = trucks.vehicle_type or ( messages2.veihcle_type = '7' and trucks.vehicle_type = '1' or messages2.veihcle_type = '7' and trucks.vehicle_type = '2' )  or ( messages2.veihcle_type = '1' and trucks.vehicle_type = '7' or messages2.veihcle_type = '2' and trucks.vehicle_type = '7' )  ORDER BY trucks.uid, day DESC";
$sth = $dbh->prepare($PG_COMMAND)
    or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute(  )
    or die "Couldn't execute statement: " . $dbh->errstr;



$dbh->disconnect();
