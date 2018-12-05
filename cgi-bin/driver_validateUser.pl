use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/generateContactUserForm.pl";
require "../cgi-bin/generateErrorPage.pl";
require "../cgi-bin/getEmailFromUserID.pl";
require "../cgi-bin/validateUserID.pl";

my $ID1=576481439;
my $ID2=2;

my $ret1 = validateUserID( $ID1 );
my $ret2 = validateUserID( $ID2 );

print "\$ret1 = $ret1\n";
print "\$ret2 = $ret2\n";
