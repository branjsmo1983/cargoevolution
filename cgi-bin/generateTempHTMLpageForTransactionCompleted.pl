use strict;
use warnings;
use Fcntl qw(:flock SEEK_END);

require "../cgi-bin/get_temp_filename.pl";
require "../cgi-bin/validateUserID.pl";
require "../cgi-bin/generateHTMLheader.pl";
require "../cgi-bin/generateHTMLopenTag.pl";
require "../cgi-bin/generateHTMLFooterFile.pl";

sub generateTempHTMLpageForTransactionCompleted
{
    my $messageID = $_[0];
    my $userID = $_[1];
    my $sid=$_[2];
    
    my $userID_valid = validateUserID( $userID, $sid );
    
    if( $userID_valid eq "False" )
    {
        exit;
    }
    
    my $temp_filename = get_temp_filename(".html", "/home2/cargoevo/public_html/tmp");
    
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

    my $title="Clicca per confermare il completamento della transazione";
    my $message_to_the_user="";
    my $cgi_script="eraseMessage.pl";

    print $fh "<body>\n";
    print $fh "<header>$title<\/header>\n";
    print $fh "<p>$message_to_the_user</p>\n";
    print $fh "<div>\n";
    print $fh "<center>\n";
    print $fh "<form action=\"/cgi-bin/$cgi_script\" method=\"post\" enctype=\"multipart/form-data\">\n";
    print $fh "<p>\n";
    print $fh "<input type=\"hidden\" value=\"$messageID\"/ id=\"MsgID\" name=\"MsgID\">\n</p>\n";
    print $fh "<p>\n";
    print $fh <<EOF;
<button type="submit" class="button positive">
<img alt="ok" src="http://www.blueprintcss.org/blueprint/plugins/buttons/icons/tick.png" />Conferma</button> 
EOF
    # print $fh "<input type=\"submit\" value=\"Conferma\"/>\n</p>\n";
    print $fh "</form>";
    print $fh "</center>\n";
    print $fh "</div>\n";
    generateHTMLFooterFile( $fh ); 
    print $fh "</body>\n</html>\n";

    flock($fh, LOCK_UN) or die "Cannot lock temporary file $!\n";

    return $temp_filename;
}
1;
