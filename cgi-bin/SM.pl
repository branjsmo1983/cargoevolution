use cPanelUserConfig;
use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use MIME::Lite;
use Net::SMTP::SSL;
use Time::HiRes;
use WWW::Mailgun;
use strict;
use warnings;
$ENV{PERL_LWP_SSL_VERIFY_HOSTNAME} = 0;
#use Email::Sender::Simple qw(sendmail);
#use Email::Sender::Transport::SMTP qw();
#use Email::Simple;
#use Try::Tiny;
#use Time::HiRes qw(usleep nanosleep);


sub SM
{
  my $dstEmail=$_[0];
    my $subject=$_[1];
      my $mailBody=$_[2];
        my $srcEmail=$_[3];
          my $skypeDst=$_[4];
            my $from= 'info@cargoevolution.com';
             #my $host = '69.89.31.86';
                my $host = "mail.cargoevolution.com";
                  #my $host = 'smtp.gmail.com';
                    my $SMTP_PORT = '26';
                      #my $SMTP_PORT = '587';
                         #open(LOG,">/home2/cargoevo/tmp/sendEmailFunct.log");

                            #*STDERR = *LOG;
                               #*STDOUT = *LOG;
   my $mg = WWW::Mailgun->new({ 
        key => 'key-723120d2be335f7ef5fd93c294b053c8',
        domain => 'mg.cargoevolution.com',
        from => 'info@mg.cargoevolution.com' # Optionally set here, you can set it when you send
    });

  $mg->send({
          to => "$dstEmail",
          subject => "$subject",
          text => "$mailBody",
    });

  }
 1;
