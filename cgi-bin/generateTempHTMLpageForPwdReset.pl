#!/usr/bin/perl

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

sub generateTempHTMLpageForPwdReset
{
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

    my $title="Modifica la tua password";
    my $message_to_the_user="";
    my $cgi_script="pwdReset.pl";

    print $fh "<body>\n";
    print $fh "<header>$title<\/header>\n";
    print $fh "<p>$message_to_the_user</p>\n";
    print $fh "<div>\n";
    print $fh "<article>\n";
    print $fh "<form action=\"/cgi-bin/$cgi_script\" method=\"post\" enctype=\"multipart/form-data\">\n";
    print $fh <<EOF;
<p>
Password: <input type=\"password\" required="required" id="password" name="password" size="10" ></input>
</p>
<p>
Conf. Pass.: <input type=\"password\" required="required" id="password_c" name="password_c" size="10" ></input>
</p>
<p>
<input type=\"hidden\" id="code" name="code" value="$code" />
</p>
<button type="submit" class="button positive">
<img alt="ok" src="http://www.blueprintcss.org/blueprint/plugins/buttons/icons/tick.png" />Reset</button> 
EOF
    print $fh "</form>";
    print $fh "</article>\n";
    print $fh "</div>\n";
    generateHTMLFooterFile( $fh );
    print $fh <<EOF;
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
    print $fh "</body>\n</html>\n";

    flock($fh, LOCK_UN) or die "Cannot lock temporary file $!\n";

    return $temp_filename;
}
1;
