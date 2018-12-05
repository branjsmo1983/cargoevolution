use strict;
use warnings;

sub media
{
	my $num_feedback = scalar(@_);
	my $mediafinale=0;
	foreach my $feedback (@_){
		$mediafinale += $feedback;
	}

	if( $num_feedback )
	{
		my $risultato = ($mediafinale / $num_feedback);
		my $resto = ($mediafinale % $num_feedback);
		#print "la somma di tutti i feedback è = $mediafinale \n";
		#print "la media finale dei feedback è = $risultato \n";
		#print "l'eventuale resto è = $resto \n";

		return $risultato;
	}
	return -1;

}
1;
