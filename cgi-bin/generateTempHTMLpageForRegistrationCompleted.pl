use strict;
use warnings;
use Fcntl qw(:flock SEEK_END);
use CGI::Session;

require "../cgi-bin/get_temp_filename.pl";
require "../cgi-bin/validateUserID.pl";
require "../cgi-bin/generateHTMLheader.pl";
require "../cgi-bin/generateHTMLopenTag.pl";
require "../cgi-bin/generateHTMLFooterFile.pl";

sub generateTempHTMLpageForRegistrationCompleted
{
    my $sid=$_[0];
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

    my $title="Clicca per confermare la registrazione dell'account";
    my $message_to_the_user="";
    my $cgi_script="enableUser.pl";

    print $fh "<body>\n";
    print $fh "<header>$title<\/header>\n";
    print $fh "<p>$message_to_the_user</p>\n";
    print $fh "<div>\n";
    print $fh "<center>\n";
    print $fh "<form action=\"/cgi-bin/$cgi_script\" method=\"post\" enctype=\"multipart/form-data\">\n";
    print $fh <<EOF;
<p>
<input type=hidden id=sid name=sid value=$sid />
</p>
<p>
<input type=\"hidden\" id="code" name="code" value="$code" />
</p>
<button type="submit" class="button positive">
<img alt="ok" src="http://www.blueprintcss.org/blueprint/plugins/buttons/icons/tick.png" />Conferma</button> 
EOF
    print $fh "</form>";
    print $fh "</center>\n";
    print $fh "</div>\n";
    generateHTMLFooterFile( $fh ); 
    print $fh "</body>\n</html>\n";

    flock($fh, LOCK_UN) or die "Cannot lock temporary file $!\n";

    return $temp_filename;
}
1;
