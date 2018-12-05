use cPanelUserConfig;
use strict;
use warnings;
use Email::MIME;
require "../cgi-bin/SM.pl";
require "../cgi-bin/sendEmailSendinBlue.pl";
use Try::Tiny;

sub sendEmailFunct
{
  my $dstEmail=$_[0];
  my $subject=$_[1];
  my $mailBody=$_[2];
  my $srcEmail=$_[3];
  my $message = Email::MIME->create(
 header_str => [
 From    => 'info@cargoevolution.com',
 To      =>  $dstEmail,
 Subject =>  $subject,
 ],
 attributes => {
 encoding => 'quoted-printable',
 charset  => 'UTF-8',
 },
 body_str => $mailBody,
 );
# send the message
 use Email::Sender::Simple qw(sendmail);
 my $rand_val = rand();
 # check if the email is from alice or hotmail and use sending blue for this email address'
 my $email_type_bad="False";
 # cinquinatrasporti
 if( $dstEmail =~ m/tiscali/ or $dstEmail =~ m/alice/ or $dstEmail =~ m/cinquinatrasporti/ or $dstEmail =~ m/outlook/  or $dstEmail =~ m/hotmail/ or $subject =~ m/reset/ )
 {
   $email_type_bad="True";
 }

 try {
      if( $rand_val < 0.90 and ($email_type_bad eq "False") )
      {
          SM($dstEmail, $subject, $mailBody );
      }
      else
      {
        if( $subject =~ m/resetMMMMMSSS/ )
        {
          # do not use sandmail
          sendmail($message);use Time::HiRes qw(usleep nanosleep);
        }
        else
        {
          my $res = sendEmailSendinBlue($dstEmail, $subject, $mailBody );
          # STUB SendinBlue jammed 2018_02_20 GiorgiuttiM
          # SM($dstEmail, $subject, $mailBody );
          # my $res = "True";
          if( $res eq "False" )
          {
              sendmail($message);use Time::HiRes qw(usleep nanosleep);
          }
        }
      }

 } catch {
      #warn "caught error: $_";
      sendmail($message);use Time::HiRes qw(usleep nanosleep);
};

#
}
1;
