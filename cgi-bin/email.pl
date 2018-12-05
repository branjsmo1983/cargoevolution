use cPanelUserConfig;
use Mail::CheckUser qw(check_email last_check);

sub email{
  my $email = $_[0];

    if(check_email($email)) {
        #print "E-mail address <$email> is OK\n";
	return 1;
    } else {
        #print "E-mail address <$email> isn't valid: ",
              last_check()->{reason}, "\n";
	return 0;
    }
}
1;
