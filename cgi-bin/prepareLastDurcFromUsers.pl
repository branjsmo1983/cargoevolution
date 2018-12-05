#!/usr/bin/perl

use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use Path::Class;
use DBI;
use DBD::Pg;
use DBD::Pg qw(:pg_types);
use strict;
use warnings;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
print header (-charset => 'UTF-8');

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/getLastDURCFromUserID.pl";
require "../cgi-bin/generateHTMLopenTag.pl";
require "../cgi-bin/generateHTMLheader.pl";
require "../cgi-bin/validateUserID.pl";
require "../cgi-bin/getAdminHash.pl";

my $q = CGI->new();

my $sid = $q->param('sid');

my $usession = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
my $uid = $usession->param('username');
my $user_valid = validateUserID($uid, $sid  );

if( $user_valid eq "False" )
{
  exit;
}

if ( getAdminHash() eq $uid or "2cff49e7376ab1b303b40e5e66c3795a" eq  $uid or "23f83ef1ed40e8cf5e7184591640e4aa" eq $uid )
{

}
else
{
  print "Forbidden!";
  exit;
}

generateHTMLopenTag();
generateHTMLheader("Admin Tools");

my $PG_COMMAND=qq{SELECT id,email,username,company_name, vat_number FROM users3};

my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
   or die $DBI::errstr;

my $sth = $dbh->prepare($PG_COMMAND)
   or die "Couldn't prepare statement: " . $dbh->errstr;

$sth->execute()
   or die "Can't execute SQL statement: "  . $dbh->errstr;

my @filenames;
my @emails;
my @vat_numbers;

while (my @row = $sth->fetchrow_array) {  # retrieve one row
    # generate filename
    my $email=$row[1];
    my $uname=$row[2];
    my $company_name=$row[3];
    my $vat_number=$row[4];
    my $filename="tmp$uname$company_name";
    # remove whitespaces
    $filename =~ s/\s//g;
    # remove tabs
    $filename =~ s/\t//g;
    # remove carrige
    $filename =~ s/\r//g;
    # remove special characters
    $filename =~ s/\W//g;
    $filename = "$filename.pdf";

    my $uid = $row[0];
    my $result = getLastDURCFromUserID( $uid, $filename );
    push @emails, $email;
    # escape VAT number
    $vat_number =~ s/\s//g;
    # remove tabs
    $vat_number =~ s/\t//g;
    # remove carrige
    $vat_number =~ s/\r//g;
    # remove special characters
    $vat_number =~ s/\W//g;

    push @vat_numbers, $vat_number;

    if( $result )
    {
      $filename = $result;
      push @filenames, $result;

      print "<p>$email, ditta  $company_name, P.IVA $vat_number: <a href=/tmp/$filename> Ultimo DURC </a></hr></p>\n";
    }
    else
    {
       # warn that no file has benn uploaded yet
       print "<p>$email, P.IVA $vat_number: <a> DURC non trovato </a></hr></p>\n";
       push @filenames, " ";
    }

}

# create text file and compressed archive
my $ref_txt = '/home2/cargoevo/public_html/tmp/report_durc.txt';
open(my $fh, '>', $ref_txt) or die "Could not open file '$ref_txt' $!";

for(my $i=0; $i < scalar @emails; $i++)
{
   print $fh $emails[$i]." ".$vat_numbers[$i];
   print $fh " ";
   print $fh $filenames[$i];
   print $fh "\n";
}

close $fh;

my $string_filenames = join(' ', @filenames);
my $command = "cd /home2/cargoevo/public_html/tmp && tar -cjvf durc.tar.bz2 $string_filenames report_durc.txt &";
system($command);
print "<p> Tarball:</p>\n";
print "<p><a href=\"/tmp/durc.tar.bz2\">www.cargoevolution.com/tmp/durc.tar.bz2</a></p>";
