use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

sub cleanPhoneNumbers
{
  my $input_phone = $_[0];
  $input_phone =~ s/ //g;
  $input_phone =~ s/-//g;
  $input_phone =~ s/\///g;
  $input_phone =~ s/#//g;

  return $input_phone;
}
1;
