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

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/getTripInformationFromMID.pl";
require "../cgi-bin/getEmailFromUserID.pl";

sub queueEmail
{
  my $dst_mail = $_[0];
  my $subject = $_[1];
  my $body = $_[2];
  my $nice = $_[3];

  my $database_name=getDatabaseName();
  my $db_username=getDatabaseUsername();
  my $db_pwd=getDatabasePwd();

  # connect to the database
  my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
     or die $DBI::errstr;

  my $PG_COMMAND = "INSERT into mail_regional(mail_to, subject, body, nice) VALUES( ?, ?, ?, ?)";

  my $sth = $dbh->prepare($PG_COMMAND)
    or die "Couldn't prepare statement: " . $dbh->errstr;

  $sth->execute( $dst_mail, $subject, $body, $nice )
      or die "Can't execute SQL statement SELECT: $dbh::errstr\n";

}
1;
