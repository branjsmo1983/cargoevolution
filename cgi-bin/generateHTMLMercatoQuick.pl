#!/usr/bin/perl

use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Session;
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
use Path::Class;
use DBI;


require "../cgi-bin/italia.pl";
require "../cgi-bin/generateHTMLSelectorRegionIT.pl";
require "../cgi-bin/generateHTMLSelectorProvinceIT.pl";
require "../cgi-bin/american2EuropeanData.pl";
require "../cgi-bin/getVeihcleType.pl";
require "../cgi-bin/generateHTMLResultTableChat.pl";
require "../cgi-bin/preparePGCondition.pl";
require "../cgi-bin/getRegionIT.pl";
require "../cgi-bin/postDBIexecute.pl";
require "../cgi-bin/preparePGConditionData.pl";
require "../cgi-bin/preparePGConditionProvince.pl";
require "../cgi-bin/preparePGConditionVehicle.pl";
require "../cgi-bin/validateUserID.pl";
require "../cgi-bin/generatePGTimestamp.pl";
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getPhoneNumbers.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/getCompanyNameFromUserId.pl";
require "../cgi-bin/getEmailFromUserID.pl";
require "../cgi-bin/convertPGtimestamp2EurDateTime.pl";

my $q = CGI->new();
my $sid = $q->param('sid');
my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $userId = $session->param("username");
my $companyName = getCompanyNameFromUserId($userId);
my $phoneNumber = getPhoneNumbers($userId);
my $email = getEmailFromUserID($userId);

print <<EOF;
<!DOCTYPE html>
<html lang="en">

  <head>
	<title>Cargoevolution</title>
    <meta charset="utf-8">
    <meta http-equiv="cache-control" content="no-cache, must-revalidate, post-check=0, pre-check=0" />
    <meta http-equiv="cache-control" content="max-age=0" />
    <meta http-equiv="expires" content="0" />
    <meta http-equiv="expires" content="Tue, 01 Jan 1980 1:00:00 GMT" />
    <meta http-equiv="pragma" content="no-cache" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
		<meta charset="utf-8" />
	<link rel="icon" type="image/png" href="/mercatino/images/icons/cargoevo.png"/>

    <!-- Bootstrap core CSS -->
    <link href="/mercatino/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom fonts for this template -->
    <link href="/mercatino/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <link href='https://fonts.googleapis.com/css?family=Lora:400,700,400italic,700italic' rel='stylesheet' type='text/css'>
    <link href='https://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800' rel='stylesheet' type='text/css'>
	<link rel="stylesheet" type="text/css" href="/mercatino/fonts/iconic/css/material-design-iconic-font.min.css">
	
    <!-- Custom styles for this template -->
    	<link rel="stylesheet" type="text/css" href="/mercatino/animate/animate.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="/mercatino/css-hamburgers/hamburgers.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="/mercatino/animsition/css/animsition.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="/mercatino/select2/select2.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="/mercatino/daterangepicker/daterangepicker.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="/mercatino/noui/nouislider.min.css">
<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="/mercatino/css/util.css">
	<link rel="stylesheet" type="text/css" href="/mercatino/css/main.css">
  <link href="/mercatino/css/clean-blog.min.css" rel="stylesheet">

  </head>

  <body>

    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light fixed-top" id="mainNav">
      <div class="container">
      <a class="navbar-brand" href="javascript:history.back()">Torna indietro</a>
			<div class="collapse navbar-collapse" id="navbarResponsive">
			  <ul class="navbar-nav ml-auto">
			    <li class="nav-item">
			      <a class="nav-link" href="#form">Inserisci un annuncio</a>
			    </li>
			    <li class="nav-item">
			      <a class="nav-link" href="#works">Leggi gli annunci</a>
			    </li>
			  </ul>
			</div>
		</div>
	<!-- <div class="w-100"></div>

			<div class="col-md-auto">
				<button class="navbar-brand" href="index.html"><h3>Torna indietro</h3></button>
			</div>
					-->
	<!--	</div>
      </div> 			-->
    </nav>

    <!-- Page Header -->
    <header class="masthead" style="background-image: url('/mercatino/img/camionMercedesAzzurri.jpg')">
	<a name="header"></a>
      <div class="overlay"></div>
      <div class="container">
        <div class="row">
          <div class="col-lg-8 col-md-10 mx-auto">
            <div class="site-heading">
              <h1>Cerco-Offro-Vendo</h1>
              <span class="subheading">Sezione dedicata a chi cerca/vende autoveicoli</span>
            </div>
          </div>
        </div>
      </div>
    </header>

    <!-- Main Content -->
   
    <div class="container ">
      <div class="row">
		<div class="col-lg-1 col-md-2">
		<a class="btn btn-outline-secondary" href="#header">Torna sù</a>
		</div>
        <div class="col-lg-8 col-md-10 mx-auto">
			<!-- <div class="wrap-contact100"> -->
      			<a name="form"></a>
			<form id="mercatinoForm" name="mercatinoForm" action="/cgi-bin/insertMercatoQuick.pl" method="post" accept-charset="utf-8" enctype="multipart/form-data"  class="contact100-form validate-form container-contact100">
				<span class="contact100-form-title">
					$companyName , pubblica il tuo annuncio
					<input type="hidden" id="company" name="company" value ="$companyName">
					<input type="hidden" id="phone" name="phone" value ="$phoneNumber">
					<input type="hidden" id="email" name="email" value ="$email">
					<input type="hidden" id="sid" name="sid" value ="$sid">
					<input type="hidden" id="typology" name="typology" value ="1">
				</span>
				<div class="wrap-input100 validate-input bg0 rs1-alert-validate" data-validate = "Per cortesia, compila questo campo !!">
					<span class="label-input100">Messaggio</span>
					<textarea class="input100" name="message" id="message" rows="10" placeholder="Descrivi chi sei e/o cosa stai cercando..."></textarea>
				</div>

				<div class="container-contact100-form-btn">
					
							<button class="contact100-form-btn" type="submit">
								<span>
									Conferma
									<i class="fa fa-long-arrow-right m-l-7" aria-hidden="true"></i>
								</span>
							</button>
					
				</div>
			</form>
			<hr>
		</div>
	</div>
	
		
		<div class="col-lg-1 col-md-2">
			<a class="btn btn-outline-secondary" href="#header">Torna sù</a>
		</div>
		
		<div class="col-lg-8 col-md-10 mx-auto">
			<a name="works"></a>
			<h1 class="post-preview post-title">Cerca tra gli annunci</h1></a><br>
			<hr class="style_shadow">
EOF
my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();
                   # connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;
  my $PG_COMMAND="select DISTINCT company, phone, email, message, data, id from mercato_quick where typology = '1' order by data DESC ";
  my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

  $sth->execute()
     or die "Can't execute SQL statement: $dbh::errstr\n";
		  my @row;
			while (@row = $sth->fetchrow_array) {
				
						my $creation_time = convertPGtimestamp2EurDateTime( $row[4] );
						my $myDate = substr $creation_time, 0, 10;
						my $findE = "è";
						my $replaceE = "&egrave;";
						my $findA = "à";
						my $replaceA = "&agrave;";
						my $findU = "ù";
						my $replaceU = "&ugrave;";
						my $findO = "ò";
						my $replaceO = "&ograve;";
						my $findI = "ì";
						my $replaceI = "&igrave;";
						my $find_dot = "!";
						my $replace_dot = " e ";
						my $user = $row[0];
						my $message = $row[3];
						my $annuncioID = $row[5];
						my $tel = $row[1];
						my $mail = $row[2];
						$user =~ s/$findE/$replaceE/g;
						$user =~ s/$findA/$replaceA/g;
						$user =~ s/$findU/$replaceU/g;
						$user =~ s/$findO/$replaceO/g;	
						$user =~ s/$findI/$replaceI/g;

						$message =~ s/$findE/$replaceE/g;
						$message =~ s/$findA/$replaceA/g;
						$message =~ s/$findU/$replaceU/g;
						$message =~ s/$findO/$replaceO/g;	
						$message =~ s/$findI/$replaceI/g;

						$tel =~ s/$find_dot/$replace_dot/g;
						
			if($user ne $companyName){
						print"
									<div class=\"post-preview\">
										<a href=\"#\">
									<h3 class=\"post-subtitle\">
									Messaggio: $message<br>
									</h3>
									<h4 class=\"post-subtitle\">
									Contatti:$tel, $mail
									</h4>
									</a> <p class=\"post-meta\">Messaggio inserito da $user in data $myDate </p>
									</div><hr>
						";
						}else{
											print"
									<div>
										<form class=\"post-preview\" action=\"/cgi-bin/deleteMercatoQuick.pl\" method=\"post\" accept-charset=\"utf-8\" enctype=\"multipart/form-data\">
											<input type=\"hidden\" name=\"mid\" id=\"mid\" value=\"$annuncioID\">
											<input type=\"hidden\" name=\"sid\" id=\"sid\" value=\"$sid\">
											<a href=\"#\">
											<h3 class=\"post-subtitle\">
											Messaggio: $message<br>
											</h3>
											<h4 class=\"post-subtitle\">
											Contatti= telefono: $tel<br> email: $mail
											</h4>
											</a> <p class=\"post-meta\">Messaggio inserito da $user in data $myDate </p>
											<input class=\"btn btn-primary\" type=\"submit\" value=\"Rimuovi il tuo annuncio\"/>
										</form>
									</div><hr>
						";

						}
					
				}
print<<EOF;
				<!--
			  <div class=\"post-preview\">
			    <a href=\"post.html\">
			      <h3 class=\"post-subtitle\">
				Man must explore, and this is exploration at its greatest
			      </h3>
			      <h4 class=\"post-subtitle\">
				Problems look mighty small from 150 miles up
			      </h4>
			    </a>
			    <p class=\"post-meta\">Posted by
			      <a href=\"#\">Start Bootstrap</a>
			      on September 24, 2018</p>
			  </div>
			  <hr>
			  <div class=\"post-preview\">
			    <a href=\"post.html\">
			      <h3 class=\"post-subtitle\">
				I believe every human has a finite number of heartbeats. I don't intend to waste any of mine.
			      </h3>
 				<h4 class=\"post-subtitle\">
				Problems look mighty small from 150 miles up
			        </h4>
			    </a>
			    <p class=\"post-meta\">Posted by
			      <a href=\"#\">Start Bootstrap</a>
			      on September 18, 2018</p>
			  </div>
			  <hr>
				-->
		</div>
	</div>
          <!-- Pager -->
	<div class="row justify-content-md-center">
		<div class="col-md-auto"
          <div class="clearfix">
            <a class="btn btn-primary float-right" href="javascript:history.back()">Torna indietro</a>
          </div>
     </div>     
        </div>
      </div>
    </div>

    <hr>

    <!-- Footer -->
    <footer>
      <div class="container" >
        <div class="row">
          <div class="col-lg-8 col-md-10 mx-auto">
            <p class="copyright text-muted">Copyright &copy; Cargoevolution</p>
          </div>
        </div>
      </div>
    </footer>

    <!-- Bootstrap core JavaScript -->
		    <script src="/mercatino/vendor/jquery/jquery.min.js"></script>
    <script src="/mercatino/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
	<script src="/mercatino/bootstrap/js/popper.js"></script>
    <!-- Custom scripts for this template -->
    <script src="/mercatino/js/clean-blog.min.js"></script>
    <script src="/mercatino/animsition/js/animsition.min.js"></script>
<!--===============================================================================================-->
<!-- 	<script src="/mercatino/js/form.js"></script> -->
	<script src="/mercatino/select2/select2.min.js"></script>

<!--===============================================================================================-->
	<script src="/mercatino/daterangepicker/moment.min.js"></script>
	<script src="/mercatino/daterangepicker/daterangepicker.js"></script>
<!--===============================================================================================-->
	<script src="/mercatino/countdowntime/countdowntime.js"></script>
<!--===============================================================================================-->
<script src="/mercatino/noui/nouislider.min.js"></script> 
<!--===============================================================================================-->
	<script src="/mercatino/js/main.js"></script>
	
<!-- Global site tag (gtag.js) - Google Analytics -->
 <!-- <script async src="https://www.googletagmanager.com/gtag/js?id=UA-23581568-13"></script> -->
<script> 
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-23581568-13');

  </body>

</html>

EOF




