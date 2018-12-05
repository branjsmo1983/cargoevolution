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
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/getCompanyNameFromUserId.pl";
require "../cgi-bin/convertPGtimestamp2EurDateTime.pl";

my $q = CGI->new();
my $sid = $q->param('sid');
my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $userId = $session->param("username");
my $companyName = getCompanyNameFromUserId($userId);

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
	<!-- <a href="javascript:history.back()"> -->
      <a class="navbar-brand" href="javascript:history.back()">Torna indietro</a>
     <!--   <button class="navbar-brand" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
          Menu
          <i class="fa fa-bars"></i>
        </button> -->
	<!--  <div class="row justify-content-md-center">
		<div class="col-md-auto"> -->
			<div class="collapse navbar-collapse" id="navbarResponsive">
			  <ul class="navbar-nav ml-auto">
			    <li class="nav-item">
			      <a class="nav-link" href="#form">Inserisci un annuncio</a>
			    </li>
			    <li class="nav-item">
			      <a class="nav-link" href="#works">Cerca tra gli annunci di vendita</a>
			    </li>
			    <li class="nav-item">
			      <a class="nav-link" href="#people">Cerca tra gli annunci di ricerca</a>
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
    <header class="masthead" style="background-image: url('/mercatino/img/camionSavana.jpg')">
	<a name="header"></a>
      <div class="overlay"></div>
      <div class="container">
        <div class="row">
          <div class="col-lg-8 col-md-10 mx-auto">
            <div class="site-heading">
              <h1>Cerco/Vendo Mezzi</h1>
              <span class="subheading">Sezione dedicata a chi cerca o a chi vende Mezzi di trasporto</span>
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
			<form id="mercatinoForm" name="mercatinoForm" action="/cgi-bin/insertMercatino.pl" method="post" accept-charset="utf-8" enctype="multipart/form-data"  class="contact100-form validate-form container-contact100">
				<span class="contact100-form-title">
					$companyName , inserisci i dati per offrire o per cercare un mezzo
					<input type="hidden" id="company" name="company" value ="$companyName">
					<input type="hidden" id="sid" name="sid" value ="$sid">
				</span>
				<span class="label-input100">I campi contrassegnati con <b> * </b> sono CAMPI OBBLIGATORI</span>
				<div class="wrap-input100 validate-input bg1" data-validate="Per cortesia, inserisci quì il tuo nome completo">
					<span class="label-input100">NOME COMPLETO *</span>
					<input class="input100" id="name" type="text" name="name" placeholder="Inserisci quì il tuo nome completo">
				</div>

				<div class="wrap-input100 validate-input bg1 rs1-wrap-input100" data-validate = "Per cortesia, Scrivi quì la tua email (esempio: xxx\@yyy.zzz)">
					<span class="label-input100">Email *</span>
					<input class="input100" type="text" id="email" name="email" placeholder="Scrivi quì la tua email">
				</div>

				<div class="wrap-input100 bg1 rs1-wrap-input100">
					<span class="label-input100">Telefono</span>
					<input class="input100" type="text" id="phone" name="phone" placeholder="Scrivi il tuo numero di telefono">
				</div>

				<div class="wrap-input100 input100-select bg1">
					<span class="label-input100" id="js-service-parent">Che tipologia di inserzione stai effettuando ?</span>
					<div class="js-select-parent" id="js-select-parent">
						<select class="js-select2" id="js-select2" name="service">
							<option value="0">Per piacere, fai la tua scelta</option>
							<option value ="3"> Vendo un mezzo (o altro) </option>
							<option value ="4">Cerco un mezzo (o altro) </option>
						</select>
						<div class="dropDownSelect2"></div>
					</div>
				</div>

				<div class="w-full dis-none js-show-service">
					<div class="wrap-contact100-form-radio">
						<span class="label-input100">Che tipologia di lavoro ?</span>
						<div class="contact100-form-radio m-t-15">
							<input class="input-radio100" id="radio1" type="radio" name="type-product" value="Motrice" checked="checked">
							<label class="label-radio100" for="radio1">
								Motrice
							</label>
						</div>

						<div class="contact100-form-radio">
							<input class="input-radio100" id="radio2" type="radio" name="type-product" value="Trattore Stradale">
							<label class="label-radio100" for="radio2">
								Aperto
							</label>
						</div>

						<div class="contact100-form-radio">
							<input class="input-radio100" id="radio3" type="radio" name="type-product" value="Semirimorchio">
							<label class="label-radio100" for="radio3">
								Semirimorchio
							</label>
						</div>
						<div class="contact100-form-radio">
							<input class="input-radio100" id="radio4" type="radio" name="type-product" value="Autotreno">
							<label class="label-radio100" for="radio4">
								Autotreno
							</label>
						</div>
						<div class="contact100-form-radio">
							<input class="input-radio100" id="radio5" type="radio" name="type-product" value="Furgone">
							<label class="label-radio100" for="radio5">
								Furgone
							</label>
						</div>
						<div class="contact100-form-radio">
							<input class="input-radio100" id="radio6" type="radio" name="type-product" value="Altro" >
							<label class="label-radio100" for="radio6">
								Altro
							</label>
						</div>
					</div>

				<div class="wrap-input100 validate-input bg0 rs1-alert-validate" data-validate = "Per cortesia, compila questo campo con una breve descrizione sul tuo annuncio oppure con delle note/precisazioni sui campi compilati in precedenza">
					<span class="label-input100">Altre caratteristiche del mezzo: *</span>
					<textarea class="input100" name="message" id="message" placeholder="Descrivi chi sei o cosa stai cercando..."></textarea>
				</div>
					
					<div class="wrap-contact100-form-range">
						<span class="label-input100">Prezzo *</span>

						<div class="contact100-form-range-value">
							€<span id="value-lower" name="value-lower">500</span> - €<span id="value-upper" name="value-upper">610</span>
							<input type="text" name="from-value">
							<input type="text" name="to-value">
						</div>

						<div class="contact100-form-range-bar">
							<div id="filter-bar"></div>
						</div>
					</div>
					
				</div>



				<!--
				<div class="container">
					  <div class="row justify-content-around">
						<div class="col-md-auto">
							<span class="btn btn-success btn-file">
								Allega il tuo Curriculum<input type="file" id="cv" name="cv">
							</span>
						</div>
						<div class="col-md-auto">
						 <span class="btn btn-info btn-file">
								Allega una tua foto<input type="file" id="foto" name="foto">
							</span>
						</div>
					  </div>
				</div>
				-->
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
			<h1 class="post-preview post-title">Cerca tra gli annunci di vendita</h1></a><br>
			<hr class="style_shadow">
EOF
my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();
                   # connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;
  my $PG_COMMAND="select DISTINCT data, message, name, uid, cv, email, telephone, form, work, stipendio, id from mercatino where form = '3' order by data DESC ";
  my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

  $sth->execute()
     or die "Can't execute SQL statement: $dbh::errstr\n";
		  my @row;
			while (@row = $sth->fetchrow_array) {
				
						my $creation_time = convertPGtimestamp2EurDateTime( $row[0] );
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
						my $user = $row[3];
						my $message = $row[1];
						my $annuncioID = $row[10];
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
					if($user ne $companyName){
						print"
									<div class=\"post-preview\">
										<a href=\"#\">
									<h3 class=\"post-subtitle\">
								<b>	$row[8] </b> - 	Nome: <i> $row[2] </i><br> Contatti: $row[6] ,  $row[5]<br> Prezzo: $row[9]
									</h3>
									<h4 class=\"post-subtitle\">
									Messaggio:	$row[1]
									</h4>
									</a> <p class=\"post-meta\">Messaggio inserito da $user in data $myDate </p>
									</div><hr>
						";
						}else{
											print"
									<div>
										<form class=\"post-preview\" action=\"/cgi-bin/deleteMercatino.pl\" method=\"post\" accept-charset=\"utf-8\" enctype=\"multipart/form-data\">
											<input type=\"hidden\" name=\"mid\" id=\"mid\" value=\"$annuncioID\">
											<input type=\"hidden\" name=\"sid\" id=\"sid\" value=\"$sid\">
											<a href=\"#\">
											<h3 class=\"post-subtitle\">
											<b>	$row[8] </b> - 	Nome: <i> $row[2] </i><br> Contatti: $row[6] ,  $row[5]<br> Prezzo: $row[9]
											</h3>
											<h4 class=\"post-subtitle\">
											Messaggio:	$row[1]
											</h4>
											</a> <p class=\"post-meta\">Messaggio inserito da $user in data $myDate </p>
											<input class=\"btn btn-primary\" type=\"submit\" value=\"Rimuovi il tuo annuncio\"/>
										</form>
									</div><hr>
						";

						}
				}
print"
			 <!-- <div class=\"post-preview\">
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
			  <hr> -->
		</div>
		<div class=\"col-lg-1 col-md-2\">
			<a class=\"btn btn-outline-secondary\" href=\"#header\">Torna sù</a>
		</div>

		<div class=\"col-lg-8 col-md-10 mx-auto\">
			<a name=\"people\"></a>
			<h1 class=\"post-title\">Guarda chi cerca un mezzo</h1></a><br>
			<hr class=\"style_shadow\">
";
 my $PG_COMMAND2="select DISTINCT data, message, name, uid, cv, email, telephone, form, work, stipendio, id from mercatino where form = '4' order by data DESC ";
  my $sth2 = $dbh->prepare($PG_COMMAND2)
      or die "Couldn't prepare statement: " . $dbh->errstr;

  $sth2->execute()
     or die "Can't execute SQL statement: $dbh::errstr\n";
		  my @row2;

	while (@row2 = $sth2->fetchrow_array) {
				
						my $creation_time = convertPGtimestamp2EurDateTime( $row2[0] );
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
						my $user = $row2[3];
						my $message = $row2[1];
						my $annuncioID = $row2[10];
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
						
						if($user ne $companyName){
						print"
									<div class=\"post-preview\">
										<a href=\"#\">
									<h3 class=\"post-subtitle\">
								<b>	$row2[8] </b> - 	Nome: <i> $row2[2] </i><br> Contatti: $row2[6] ,  $row2[5]<br> Prezzo: $row2[9]
									</h3>
									<h4 class=\"post-subtitle\">
									Messaggio:	$row2[1]
									</h4>
									</a> <p class=\"post-meta\">Messaggio inserito da $user in data $myDate </p>
									</div><hr>
						";
						}else{
											print"
									<div>
										<form class=\"post-preview\" action=\"/cgi-bin/deleteMercatino.pl\" method=\"post\" accept-charset=\"utf-8\" enctype=\"multipart/form-data\">
											<input type=\"hidden\" name=\"mid\" id=\"mid\" value=\"$annuncioID\">
											<input type=\"hidden\" name=\"sid\" id=\"sid\" value=\"$sid\">
											<a href=\"#\">
											<h3 class=\"post-subtitle\">
											<b>	$row2[8] </b> - 	Nome: <i> $row2[2] </i><br> Contatti: $row2[6] ,  $row2[5]<br> Prezzo: $row2[9]
											</h3>
											<h4 class=\"post-subtitle\">
											Messaggio:	$row2[1]
											</h4>
											</a> <p class=\"post-meta\">Messaggio inserito da $user in data $myDate </p>
											<input class=\"btn btn-primary\" type=\"submit\" value=\"Rimuovi il tuo annuncio\"/>
										</form>
									</div><hr>
						";

						}
				}
print<<EOF
			<!--  <div class="post-preview">
			    <a href="post.html">
			      <h2 class="post-subtitle">
				Science has not yet mastered prophecy
			      </h2>
			     <h3 class="post-subtitle">
				We predict too much for the next year and yet far too little for the next ten.
			      </h3>
			    </a>
			    <p class="post-meta">Posted by
			      <a href="#">Start Bootstrap</a>
			      on August 24, 2018</p>
			  </div>
			  <hr>
			  <div class="post-preview">
			    <a href="post.html">
			      <h2 class="post-subtitle">
				Failure is not an option
			      </h2>
			      <h3 class="post-subtitle">
				Many say exploration is part of our destiny, but it’s actually our duty to future generations.
			      </h3>
			    </a>
			    <p class="post-meta">Posted by
			      <a href="#">Start Bootstrap</a>
			      on July 8, 2018</p>
			  </div>
			  <hr> -->
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
           <!-- <ul class="list-inline text-center">
              <li class="list-inline-item">
                <a href="#">
                  <span class="fa-stack fa-lg">
                    <i class="fa fa-circle fa-stack-2x"></i>
                    <i class="fa fa-twitter fa-stack-1x fa-inverse"></i>
                  </span>
                </a>
              </li>
              <li class="list-inline-item">
                <a href="#">
                  <span class="fa-stack fa-lg">
                    <i class="fa fa-circle fa-stack-2x"></i>
                    <i class="fa fa-facebook fa-stack-1x fa-inverse"></i>
                  </span>
                </a>
              </li>
              <li class="list-inline-item">
                <a href="#">
                  <span class="fa-stack fa-lg">
                    <i class="fa fa-circle fa-stack-2x"></i>
                    <i class="fa fa-github fa-stack-1x fa-inverse"></i>
                  </span>
                </a>
              </li>
            </ul> -->
            <p class="copyright text-muted">Copyright &copy; Your Website 2018</p>
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
	<script>
	    var filterBar = document.getElementById('filter-bar');

	    noUiSlider.create(filterBar, {
	        start: [ 2000, 20000 ],
	        connect: true,
	        range: {
	            'min': 1000,
	            'max': 100000
	        }
	    });

	    var skipValues = [
	    document.getElementById('value-lower'),
	    document.getElementById('value-upper')
	    ];

	    filterBar.noUiSlider.on('update', function( values, handle ) {
	        skipValues[handle].innerHTML = Math.round(values[handle]);
	        \$('.contact100-form-range-value input[name="from-value"]').val(\$('#value-lower').html());
	        \$('.contact100-form-range-value input[name="to-value"]').val(\$('#value-upper').html());
	    });
	</script>
<!--===============================================================================================-->
	<script src="/mercatino/js/main.js"></script>
	
<!-- Global site tag (gtag.js) - Google Analytics -->
 <!-- <script async src="https://www.googletagmanager.com/gtag/js?id=UA-23581568-13"></script> -->
<script> 
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-23581568-13');
</script>
	<script>
		\$(".js-select2").each(function(){
			\$(this).select2({
				minimumResultsForSearch: 20,
				dropdownParent: \$(this).next('.dropDownSelect2')
			});


			\$(".js-select2").each(function(){
				\$(this).on('select2:close', function (e){
					if(\$(this).val() == "Per piacere, fai la tua scelta") {
						\$('.js-show-service').slideUp();
					}
					else {
					\$('.js-show-service').slideUp();
						\$('.js-show-service').slideDown();
					}
				});
			});
		})
	</script>

  </body>

</html>

EOF




