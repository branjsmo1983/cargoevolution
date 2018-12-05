#!/usr/bin/perl
# Display dynamic contents on a web page
# run the C++ program to generate the HTML text file
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
print header;
use Path::Class;
#use autodie; # die if problem reading or writing a file

print "Content-type: text/html\n\n";
print start_html(-head=>meta({-http_equiv => 'Refresh', -content=> '5; URL=/cgi-bin/form3.pl'}));

system("table_generator.exe", "50");
 if ( $? == -1 )
 {
   print "command failed: $!\n";
 }
 else
 {
   printf "command exited with value %d\n", $? >> 8;
 }

print <<EOF;
<HTML>

<BODY BGCOLOR=WHITE TEXT=BLACK>
<CENTER><H1> Dynamic Table Generation </H1>
</CENTER>

EOF

# get the actual dynamic content
my $dir = dir("/tmp"); # /tmp
my $file = $dir->file("lesofhsd.txt");
# Read in the entire contents of a file

my $file_handle = $file->openr();

# Read in line at a time
while( my $line = $file_handle->getline() )
{
    print $line;
}
#$file->close();

print <<EOF;
</HTML>
EOF
