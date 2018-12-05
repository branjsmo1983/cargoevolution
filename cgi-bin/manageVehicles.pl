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
my $addtional_tags = "<script>\n\$( function() {\n\$( \"#date_of_loading1\" ).datepicker({ dateFormat: \"dd/mm/yy\" , dayNames: [ \"Domenica\", \"Lunedi\", \"Martedi\", \"Mercoledi\", \"Giovedi\", \"Venerdi\", \"Sabato\"], dayNamesMin: [ \"Do\", \"Lu\", \"Ma\", \"Me\", \"Gi\", \"Ve\", \"Sa\" ], $IT_month_names, $min_date, firstDay: 1 });} );\n</script>\n";
$addtional_tags = "$addtional_tags<script>\n\$( function() {\n\$( \"#date_of_loading2\" ).datepicker({ dateFormat: \"dd/mm/yy\" , dayNames: [ \"Domenica\", \"Lunedi\", \"Martedi\", \"Mercoledi\", \"Giovedi\", \"Venerdi\", \"Sabato\"], dayNamesMin: [ \"Do\", \"Lu\", \"Ma\", \"Me\", \"Gi\", \"Ve\", \"Sa\" ], $IT_month_names, $min_date, firstDay: 1 });} );\n</script>\n";

print header (-charset => 'UTF-8');
generateHTMLopenTag();
generateHTMLheader("Admin tools", $addtional_tags);

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

print <<EOF;
<div class="panel panel-primary" style="margin:20px;">
<div class="panel-heading">
<h3 class="panel-title">Inserisci mezzo ad un utente</h3>
</div>
<div class="panel-body">
<form action="/cgi-bin/insert_truck.pl" method="post" accept-charset="utf-8" enctype="multipart/form-data">
<p>
<input type="hidden" name="sid" id="sid" value="$sid">
</p>
<p>
<label for="uemail">Email dell'utente</label>
<input type="email" class="form-control input-sm" required="required" id="uemail" name="uemail" placeholder="">
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
print "<label for=\"pick_up_region\">Regione: </label>";
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

my $PG_COMMAND="select users3.email, trucks.day, trucks.vehicle_type, trucks.region, trucks.dregion from trucks INNER JOIN users3 ON (users3.id = trucks.uid) ORDER BY day DESC";
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
  $day = american2EuropeanData($day);
  my $vt = $row[2];
  my $region = $row[3];
  my $dregion = $row[4];
  my $vname = getVeihcleType( $vt );
  my $region_str = getRegionIT( $region );

print <<EOF;
<div class="panel-heading">
<h4 class="panel-title">
<a class="accordion-toggle" data-toggle="collapse" >$cnt) Email: $email, Data: $day, Regione: $region, Reg. Consegna: $dregion, Tipologia Veicolo: $vname  </a>
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

print <<EOF;
<div class="panel panel-primary" style="margin:20px;">
<div class="panel-heading">
<h3 class="panel-title">Possibili business</h3>
</div>
<div class="panel-body">
EOF

$cnt = 1;
my @business;

while(@row = $sth->fetchrow_array){
  my $uid_truck = $row[0];
  my $pur = $row[1];
  my $pup = $row[2];
  my $date1 = $row[3];
  my $date2 = $row[4];
  my $uid_cargo = $row[5];
  my $vt = $row[6];
  my $vname = getVeihcleType( $vt );
  my @array1 = @row;
  my $reference1 = \@array1;
  push @business, $reference1;

  my $email_truck = getEmailFromUserID( $uid_truck );
  my $email_cargo = getEmailFromUserID( $uid_cargo );

  print <<EOF;
  <div class="panel-heading">
  <h4 class="panel-title">
  <a class="accordion-toggle" data-toggle="collapse" >$cnt) Email Camion: $email_truck, Email Merce: $email_cargo, Regione: $pur, Data: $date1, Data Alt.: $date2, Tipologia Veicolo: $vname </a>
  </h4>
  </div>

EOF
  $cnt = $cnt + 1;
}

print <<EOF;
</div>
</div>
EOF

print <<EOF;
<div class="panel panel-primary" style="margin:20px;">
<div class="panel-heading">
<h3 class="panel-title">Possibili business per email</h3>
</div>
<div class="panel-body">
EOF

$cnt = 1;
my @businss_users;

while( $cnt <= (scalar @business) ){

  $cnt = $cnt + 1;
}
print <<EOF;
</div>
</div>
EOF

$dbh->disconnect();
