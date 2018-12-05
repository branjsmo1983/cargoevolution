use cPanelUserConfig;
use strict;
use warnings;
use Try::Tiny;


sub sendEmailSendinBlue
{
  my $dstEmail=$_[0];
  my $subject=$_[1];
  my $mailBody=$_[2];

  my $to=$dstEmail;
  $subject=qq{"$subject"};
  my $body=qq{"$mailBody"};

  my $output = `php sendEmailSendinBlue.php $to $subject $body`;
  if( $output =~ /Email sent successfully/ )
  {
    return "True";
  }
  else
  {
    return "False";
  }

  #print header (-charset => 'UTF-8');
  #print "<p>$to</p><p>$subject</p><p>$body</p>";
  #print "<p>$output</p>";


}
1;
