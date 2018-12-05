#!/usr/bin/perl

use strict;
use Fcntl qw(:flock SEEK_END);
use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";

sub updateNumEmailsMailList
{
  my $id = $_[0];
  my $PG_COMMAND=qq{update mail_list set sent_mails=1 where id=? };

  my $database_name=getDatabaseName();
  my $db_username=getDatabaseUsername();
  my $db_pwd=getDatabasePwd();

  # connect to the database
  my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
     or die $DBI::errstr;

  my $sth = $dbh->prepare($PG_COMMAND)
     or die "Couldn't prepare statement: " . $dbh->errstr;

  $sth->execute( $id )
     or die "Couldn't execute statement: " . $dbh->errstr;

  $sth->finish;
  $dbh->disconnect();

}
1;
