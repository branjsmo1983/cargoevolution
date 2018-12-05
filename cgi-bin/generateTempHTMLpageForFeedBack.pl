use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use Path::Class;
use DBI;
use File::Slurp;
use File::Basename;
use Fcntl qw( :flock );
use strict;
use warnings;

require "../cgi-bin/get_temp_filename.pl";
require "../cgi-bin/validateUserID.pl";
require "../cgi-bin/generateHTMLheader.pl";
require "../cgi-bin/generateHTMLopenTag.pl";
require "../cgi-bin/generateHTMLFooterFile.pl";
require "../cgi-bin/getTripInformationFromMID.pl";
require "../cgi-bin/getCompanyNameFromID.pl";

sub generateTempHTMLpageForFeedBack
{
    my $my_uid=$_[0];
    my $mid=$_[1];

    my $temp_filename = get_temp_filename(".html", "/home2/cargoevo/public_html/tmp");
    my ($code, $path, $suffix) = fileparse($temp_filename);
    
    open my $fh, ">", $temp_filename
        or die "could not open $temp_filename: $!";

    flock($fh, LOCK_EX) or die "Cannot lock temporary file $!\n";

    #print $fh header;
    print $fh <<EOF;
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//IT"
"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
EOF
    generateHTMLopenTag($fh);
    generateHTMLheader("Cargoevolution", " ", $fh);

    my $title="Lascia il feedback sul trasporto";
    my $message_to_the_user="";
    my $cgi_script="leaveFeedBack.pl";

    print $fh "<body>\n";
    print $fh "<header>$title<\/header>\n";
    print $fh "<p>$message_to_the_user</p>\n";
    print $fh "<div>\n";
    print $fh "<center>\n";
    print $fh "<form action=\"/cgi-bin/$cgi_script\" method=\"post\" enctype=\"multipart/form-data\">\n";
    # get trip details
    my $details = getTripInformationFromMID( $mid );
    my @company_names = getCompanyNameFromID( $mid );
    my $insertionist = $company_names[0];
    my $buyer = $company_names[1];
    my $who = "Inserzionista: $insertionist, Traspotatore: $buyer";
    print $fh "<p><textarea rows=\"6\" cols=\"50\" readonly>$who\n $details </textarea></p>\n";
    print $fh <<EOF;
<p> Scadente
<img src="/images/star_gray.png" id="1" onclick="change(['1']);">
<img src="/images/star_gray.png" id="2" onclick="change(['1', '2']);">
<img src="/images/star_gray.png" id="3" onclick="change(['1', '2', '3']);">
<img src="/images/star_gray.png" id="4" onclick="change(['1', '2', '3', '4']);">
<img src="/images/star_gray.png" id="5" onclick="change(['1', '2', '3', '4', '5']);"> Ottimo
</p>
<input type="hidden" value="0" id="curr_feed" name="curr_feed">
<input type="hidden" value="$my_uid" id="my_uid" name="my_uid">
<input type="hidden" value="$mid" id="mid" name="mid">
<p>
<textarea rows="2" cols="50" id="feedBackComment" name="feedBackComment" placeholder="Lascia un commento di feedback"></textarea>
</p>
<button type="submit" class="button positive">
<img alt="ok" src="http://www.blueprintcss.org/blueprint/plugins/buttons/icons/tick.png" />Invia</button> 
EOF
    print $fh "</form>";
    print $fh "</center>\n";
    print $fh "</div>\n";
    generateHTMLFooterFile( $fh );
    print $fh <<EOF;
<script type="text/javascript">

function change( myStringArray )
{
   var image;
   var arrayLength = myStringArray.length;

   for (var i = 0; i < arrayLength; i++) {
      //Do something
      image = document.getElementById( myStringArray[i] );
      image.src = "/images/star_ico.png";
   }

   for (var j = 4; j >= arrayLength; j--) {
      //Do something
      image = document.getElementById( (j+1) );
      image.src = "/images/star_gray.png";
   }

   var curr_feed = document.getElementById( 'curr_feed' );
   curr_feed.value = arrayLength;
}

</script>

EOF
    print $fh "</body>\n</html>\n";

    flock($fh, LOCK_UN) or die "Cannot lock temporary file $!\n";

    return $temp_filename;
}
1;
