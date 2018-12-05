sub generateHTMLheader
{
my $title=$_[0];

if( !$title)
{
    $title = "Cargoevolution";
}

my $additional_tags = $_[1];
my $fh=$_[2];

if(!$fh )
{
 $fh = STDOUT;
}
# <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.0/jquery.min.js"></script>
print $fh <<EOF;
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="Keywords" content="Cargo, Business, Smart Economy, Italy" />
<meta name="Description" content="Database for exchange cargos between small business companies" />
<title>$title</title>
<script type="text/javascript" src="/jquery-3.2.0.min.js"></script>
<script src="/jquery-3.2.0.js"></script>
<script src="/bootstrap.min.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="/chat.js"></script>
<script src="/blog.js"></script>
<script src="/jquery.imagemapster.js"></script>
<script src="/new_messages.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.js"></script>
<link rel="stylesheet" type="text/css" href="/css/cargoevolution11.css" media="screen and (min-device-width: 800px)" />
<link rel="stylesheet" media="screen and (max-device-width: 801px)" href="/css/cargoevolution_smartphone11.css" />
<link rel="stylesheet" type="text/css" href="/css/bootstrap.css" />
<link rel="stylesheet" type="text/css" href="/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="/css/landing-page.css" />
<link rel="stylesheet" type="text/css" href="/css/benvenuto2.css" />
<link rel="stylesheet" type="text/css" href="/css/benvenuto3.css" />
<link rel="icon" type="image/png" href="/vendor/images/icons/cargoevo.png"/>
<link href="https://fonts.googleapis.com/css?family=Lato:300,400,700,300italic,400italic,700italic" rel="stylesheet" type="text/css">
<script src="/notifications.js" async='async'></script>
<script src="/conditions.js" async='async'></script>
EOF
print $fh "$additional_tags\n</head>";
#<script type="text/javascript" src="http://www.openlayers.org/api/OpenLayers.js"></script>
#<script type="text/javascript" src="/openStreetMap.js"></script>


}
1;
