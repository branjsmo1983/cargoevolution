use cPanelUserConfig;
use CGI;
use CGI::Session;
use cPanelUserConfig;

require "../cgi-bin/generateErrorPage.pl";
require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
require "../cgi-bin/getLinkToLoginPage.pl";

sub validateUserID{

    my $userID=$_[0];
    my $sid=$_[1];
    my $ret;
    my $PG_COMMAND=qq{SELECT id FROM users3 WHERE id=?};
    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();
    
    # check if the session has expired
    my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
    my $log_in_valid = $session->param("_logged_in");
    
    if(  !defined $log_in_valid )
    {
        my $url = getLinkToLoginPage();
        #print "Content-type: text/html\n\n"; 

        print qq[
        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html>
        <head>
        <title>Redirecting...</title>
        <meta HTTP-EQUIV="REFRESH" CONTENT="10;URL=$url">
        </head>
        <body>
        </body>
        </html>
        ];
    }
    
    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;
  
    
    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;

    $sth->execute( $userID )
        or die "Can't execute SQL statement: $dbh::errstr\n";
     
    my @row2 = $sth->fetchrow_array;
    
    if( (scalar @row2) != 0 )
    {
        # User in database
        $ret = "True";
    }
    else
    {
        # User not in database
        $ret = "False";
        generateErrorPage("Utente non abilitato");
    }
    
    $sth->finish;
    $dbh->disconnect();
    
    return $ret;
}
1;
