#!/usr/bin/perl

use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;
use Fcntl qw(:flock SEEK_END);
use File::Slurp;
use File::Basename;

require "../cgi-bin/generateErrorPage.pl";
require "../cgi-bin/get_temp_filename.pl";
require "../cgi-bin/printTripInformation.pl";
require "../cgi-bin/generateTempHTMLpageForTransactionCompleted.pl";
require "../cgi-bin/updateBuyerID.pl";
require "../cgi-bin/insertTransaction.pl";
require "../cgi-bin/operationCompleted.pl";
require "../cgi-bin/checkMessageAvailability.pl";
require "../cgi-bin/getVehicleDetails.pl";
require "../cgi-bin/getNotesFromMessageID.pl";
require "../cgi-bin/getTripInformationFromMID.pl";
require "../cgi-bin/read_file_STUB.pl";
require "../cgi-bin/sendEmailFunct.pl";
require "../cgi-bin/getPhoneNumbers.pl";

print header (-charset => 'UTF-8');

my $q = CGI->new();
my $tmpFilename = $q->param('tmpFilename');
my $sid = $q->param('sid');
my $mail_only = $q->param('mail_only');

# use the token to avoid double messaging
my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $token = $session->param("token");
my $token_face1 = $session->param("token_face1");

if( $token ne $token_face1 )
{
   # choose next action
   my $ret=operationCompleted( $sid, "Email già inviata\n", "from_redirection");
}
elses
{
    # retreive the emails from the temporary file
    open my $fhi, "<", $tmpFilename
            or die "could not open $tmpFilename: $!";
    # read email data from file
    my $tmpFileContentsString = <$fhi>;
    close $fhi;
    #remove temporary file not to crowd the FS
    unlink $tmpFilename;

    # retreive separate field from the string
    my @trip_details = split("#", $tmpFileContentsString);
    my $num_elements_in_file = scalar @trip_details;
    my $messageID = $trip_details[0];
    my $username  = $trip_details[1];
    my $dstEmail  = $trip_details[2];
    my $srcEmail  = $trip_details[3];

    my $HTML_temp = generateTempHTMLpageForTransactionCompleted($messageID , $username, $sid);


    my @vehicle_details = getVehicleDetails( $messageID );

    # retrieve vehicle information from database

    my $ContactUserTextArea = $q->param('ContactUserTextArea');

    # generateErrorPage( "\$dstEmail = $dstEmail\n \$srcEmail = $srcEmail\n" );
    # generate temporary file (random filename) with the email data
    my $filename = get_temp_filename(".dat");

    open my $fh, ">", $filename
        or die "could not open $filename: $!";

    # use the tmp filename to get an ID for the transaction
    my ($tname, $tpath, $tsuffix) = fileparse($filename, ".dat");

    flock($fh, LOCK_EX) or die "Cannot lock temporary file $!\n";

    # get phone numbers
    my $ph_nums = getPhoneNumbers( $username );
    my @nums = split(/!/, $ph_nums);
    my $num_to_display = $nums[0];

    # Print the reference to the message and the details of the sender
    print $fh "$srcEmail (Tel. $num_to_display) ha scritto il seguente messaggio:\n\n";
    print $fh "$ContactUserTextArea\n\n";
    print $fh "Di seguito sono riportati i dettagli del trasporto:\n\n";
    printTripInformation($fh, $tmpFileContentsString, "it", "True");
    # send also the user notes
    my $notes = getNotesFromMessageID( $messageID );
    # utf8::decode( $notes );
    if( $notes )
    {
       print $fh "Note:\n $notes\n";
    }

    # print link to the temporary webpage
    print $fh "\n\nClicca il link ed accedi a cargoevolution.com, sezione \"I miei annunci\" per gestire il trasporto\n\n";
    my $IP_address="www.cargoevolution.com";

    # retrieve the basename of the HTML file for the link address
    my ($name, $path, $suffix) = fileparse($HTML_temp);

    # $name = "/tmp/$name";
    $name = "/login.html";
    print $fh "http://$IP_address$name\n\n";

    flock($fh, LOCK_UN) or die "Cannot unlock temporary file - $!\n";
    close $fh;

    # check that in the meanwhile some other user has completed the process before you
    my $isMessageAvailable=checkMessageAvailability( $messageID );

    if( $isMessageAvailable eq "False" )
    {
        # Cannot proceed redirect to something elese
        operationCompleted( $sid, "Un altro utente ti ha anticipato su questo Trasporto \n", "from_redirection");
    }
    else
    {
      # use sendmail with the account info@cargoevolution.com
      my $subject="Cargoevolution, un utente ti ha contattato (ID richiesta = $tname)";
      my $from= 'info@cargoevolution.com';
      
      # use function to send email
      my $mailBody = read_file_STUB($filename);
      
      #$mailBody = utf8::upgrade($mailBody);
      
      sendEmailFunct($dstEmail, $subject, $mailBody, $srcEmail);
        
      # send also a remainder email to the source address
      $subject="Cargoevolution richiesta inviata (ID richiesta = $tname)";
      $from= 'info@cargoevolution.com';

      my $trip_info_with_no_link = getTripInformationFromMID( $messageID );
      $trip_info_with_no_link = "$trip_info_with_no_link\n\n\n$ContactUserTextArea";
      $mailBody = "Il seguente messaggio è stato spedito all'inserzionista:\n\n--------------------------------------------------------\n$trip_info_with_no_link\n\n";
      $mailBody = "$mailBody--------------------------------------------------------\n\n";
      $mailBody = "$mailBody Messaggio automatizzato di cargoevolution.com,\n si prega di non rispondere a questo\nindirizzo mail;\n";
      #$mailBody = utf8::upgrade($mailBody);
      #  sendEmailFunct($srcEmail, $subject, $mailBody);     
      
      if( !$mail_only )
      {
        # write the ID of the buyer of the delivery
	updateBuyerID( $username, $messageID );
        # insert also the transaction into transaction table
        insertTransaction( $messageID, $HTML_temp, $filename );
      }
      else
      {
         print "Sending email only\n";
      }
      

      # choose next action
      my $ret=operationCompleted( $sid, "Email inviata con successo\n", "from_redirection");
      my $new_token= rand(10000000);
      $session->param("token_face1", "$new_token");
    }
}


