use MIME::Lite;

sub sendEmailFeedBack
{
  my $dstEmail=$_[0];
  my $subject="Invito a lasciare il feedback";
  my $mailBody= "pagina_html_dove_dare_il_feedback.html";

  #my $srcEmail= non ho idea a cosa serva
  my $from= 'info@cargoevolution.com';

  $msg = MIME::Lite->new(
                 From     => $from,
                 To       => $dstEmail,
                 Subject  => $subject,
                 Data     => $mailBody,
                 'Reply-To' => $from
                 );
  $msg->attr('content-type'
   => 'text/plain; charset=UTF-8');
  $msg->send;

#  open(MAIL, "|/usr/sbin/sendmail -t -N failure"); 
#  ## Mail Header
#  print MAIL "To: $dstEmail\n";
#  print MAIL "From: $from\n";
#  print MAIL "Subject: $subject\n\n";
#  ## Mail Body
#  print MAIL "$mailBody\n";
#  close(MAIL);
}
1;
