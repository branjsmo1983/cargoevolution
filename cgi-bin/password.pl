use cPanelUserConfig;
use strict;
use warnings;
use 5.010;

sub password{
	my $passw1=$_[0];
	my $passw2=$_[1];

	if(($passw1 eq $passw2)and (defined $passw1) and (defined $passw2)and(($passw1 ne '')or($passw2 ne ''))and(length $passw1 >=8)){
        #print "password1 <$passw1> and password2 <$passw2> are OK\n";
	return 1;
    } else {
        #print "password1 <$passw1> and password2 <$passw2> aren't valid!!\n";
	return 0;
    }

}
1;
