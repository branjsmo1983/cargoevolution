use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use CGI::Session;
use strict;
use warnings;

require "../cgi-bin/generatePGTimestamp.pl";
require "../cgi-bin/deltaTimePG.pl";
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/generateHTMLChatCombo.pl";
require "../cgi-bin/getCompanyNameFromUserId.pl";

sub generateHTMLUnreadMessagesMyChat
{
    my $sid = $_[0];

    # get the userID from the user session
    my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
    my $id = $session->param("username");

    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();

    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;

    my $PG_COMMAND="select DISTINCT chats.id, chats.text, chats.creation_time, messages2.id, chats.uid from chats  INNER JOIN messages2 ON (messages2.id = chats.mid and chats.read = 0 and chats.did=? and messages2.username=?) ";
    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute( $id, $id )
        or die "Can't execute SQL statement: $dbh::errstr\n";

    my @row;
    my $time_stamp = generatePGTimestamp();

    my $cnt=0;

    while (@row = $sth->fetchrow_array) {
       my $message = $row[1];
       my $creation_time = $row[2];
       my $mid = $row[3];
       my $oid = $row[4];
       my $company_name = getCompanyNameFromUserId( $oid );

       print "<div class=\"clip-message\">&nbsp\n";

       print "<p>Messaggio da: $company_name: &nbsp $message <a>";
       generateHTMLChatCombo($mid, $sid, 1, $oid);
       print "</a><p><hr/>\n";
       print "&nbsp </div>";

       $cnt = $cnt +1;
    }

    $sth->finish;
    $dbh->disconnect();

    return $cnt;
}
1;
