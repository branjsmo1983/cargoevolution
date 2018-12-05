#!/usr/bin/perl

use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use CGI::Session;
use DBI;
use DBD::Pg;
use DBD::Pg qw(:pg_types);
use Fcntl qw(:flock SEEK_END);
use File::Slurp;
use File::Basename;
use Digest::MD5;
use Encode;
use strict;

require "../cgi-bin/generatePGTimestamp.pl";
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/operationCompleted.pl";
require "../cgi-bin/escapeTextForPostgres.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/read_file_bin.pl";
require "../cgi-bin/getUidFromEmail.pl";

my $q = CGI->new();
$q::POST_MAX = 1024 * 5000;
my $safe_filename_characters = "a-zA-Z0-9_.-";
my $upload_dir = "/home2/cargoevo/public_html/tmp";
my $filename = $q->param('files');
my $sid = $q->param('sid');
my $demail = $q->param('demail');

my $uid = getUidFromEmail( $demail );

my $durc_file_inserted;

if ( $filename )
{
    $durc_file_inserted="True";
    my ( $name, $path, $extension ) = fileparse ( $filename, '..*' ); $filename = $name . $extension;
    $filename =~ tr/ /_/; $filename =~ s/[^$safe_filename_characters]//g;
    if ( $filename =~ /^([$safe_filename_characters]+)$/ ) { $filename = $1; } else { die "Filename contains invalid characters"; }
    my $upload_filehandle = $q->upload("files");
    open ( UPLOADFILE, ">$upload_dir/$filename" ) or die "$!"; binmode UPLOADFILE;

    while ( <$upload_filehandle> )
     {
     print UPLOADFILE;
     }

    close UPLOADFILE;
}
else
{
  exit;
}

my $timestamp=generatePGTimestamp();

# connect to database
my $database_name=getDatabaseName();
my $db_username=getDatabaseUsername();
my $db_pwd=getDatabasePwd();

# connect to the database
my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
  or die $DBI::errstr;

my $json = qq{{ "success" : "PRE" }};

if( $durc_file_inserted eq "True" )
{
  my $fn="$upload_dir/$filename";

  # escape filename
  # remove whitespaces
  $filename =~ s/\s//g;
  # remove tabs
  $filename =~ s/\t//g;
  # remove carrige
  $filename =~ s/\r//g;

  $json = qq{{ "success" : "$fn" }};
  #insert the file into the durc database
  my $PG_COMMAND="insert into durc(uid, pdf, creation_time, filename) values(\'$uid\', ?, TIMESTAMP WITH TIME ZONE \'$timestamp\-07\', \'$filename\')";
  my $sth = $dbh->prepare($PG_COMMAND)
    or die "Couldn't prepare statement: " . $dbh->errstr;

  my $filedata = read_file_bin($fn);
    $sth->bind_param(1, ($filedata), { pg_type => DBD::Pg::PG_BYTEA });

  $sth->execute( )
    or die "Can't execute SQL statement: $dbh::errstr\n";

  $sth->finish;
  #undef $filedata;
}
else
{
  $json = qq{{ "error" : "KO" }};
}

$dbh->disconnect();

#print $q->header(-type => "text/html", -charset => "utf-8");
print $q->redirect( "updateAccount.pl?sid=$sid" );
