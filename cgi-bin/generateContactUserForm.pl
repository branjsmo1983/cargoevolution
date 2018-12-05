use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);

require "../cgi-bin/generateHTMLFooter.pl";
require "../cgi-bin/generateHTMLheader.pl";
require "../cgi-bin/printTripInformation.pl";

sub generateContactUserForm{
    
    print header (-charset => 'UTF-8');
    my $email = $_[0];
    my $email_of_mine = $_[1];
    my $tmpFilename=$_[2];
    my $notes=$_[3];
    my $tmpFileContentsString=$_[4];
    my $sid=$_[5];
    my $mail_only = $_[6];
    
    # utf8::downgrade( $notes );
    # utf8::encode( $notes );
    print "<html>\n";
    generateHTMLheader("Contatta l'inserzionista");
    print "<body translate=\"no\">\n<header>Scrivi un messaggio all'offerente</header>\n";
    # draw the text area
    my $cgi_script="sendEmail.pl";
    print "<center>\n";
    print "<p>\n<a href=\"javascript:history.back()\">Clicca qui per tornare Indietro</a>\n</p>\n";
    print "<p>\nDettagli trasporto:</p>\n";
    print "<p>\n";
    print "<textarea readonly name=\"MessageTextArea\" cols=\"53\" rows=\"12\" >\n";
    printTripInformation("STDOUT", $tmpFileContentsString, "it");
    print "Note:\n";
    print "$notes";
    print "</textarea>\n";
    print "</p>\n";
    print "<form id=\"ContactUserForm\" name=\"ContactUserForm\" action=\"/cgi-bin/$cgi_script\" method=\"post\" enctype=\"multipart/form-data\">\n";
    print "<textarea name=\"ContactUserTextArea\" maxlength=\"120\" cols=\"40\" rows=\"20\" placeholder=\"Scrivi qui il tuo messaggio ...\"></textarea>\n";
    print "<p>\n<input id=\"ContactSendButton\" type=\"submit\" name=\"ContactSendButton\" value=\"Invia\" />\n</p>\n";
    # print "<p>\n<input id=\"dstEmail\" type=\"hidden\" name=\"dstEmail\" value=\"$email\" />\n</p>\n";
    # print "<p>\n<input id=\"srcEmail\" type=\"hidden\" name=\"srcEmail\" value=\"$email_of_mine\" />\n</p>\n";
    # print an hiddenfield with the temporary filename
    print "<p>\n<input id=\"tmpFilename\" type=\"hidden\" name=\"tmpFilename\" value=\"$tmpFilename\" />\n</p>\n";
    print "<p>\n<input id=\"sid\" type=\"hidden\" name=\"sid\" value=\"$sid\" />\n</p>\n";
    # 
    if( $mail_only )
    {
       print "<p>\n<input id=\"mail_only\" type=\"hidden\" name=\"mail_only\" value=\"$mail_only\" />\n</p>\n";
    }
    # pass the email information with CGI
    # CGI->new("dstEmail=$email");
    # CGI->new("srcEmail=$email_of_mine");
    print "</form>\n";
    print "</center>\n";
    generateHTMLFooter();
    print "</body>\n<html>\n";
}
1;
