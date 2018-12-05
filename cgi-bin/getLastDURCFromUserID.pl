use CGI qw(:standard);
use CGI::Carp 'fatalsToBrowser';
use DBI;
use strict;
use warnings;
use utf8;

require "../cgi-bin/getDatabaseName.pl";
require "../cgi-bin/getDatabasePwd.pl";
require "../cgi-bin/getDatabaseUsername.pl";
use Digest::MD5;
use Encode;
use FileHandle;


sub getLastDURCFromUserID
{
    # Reteive the emial of the user and generate the input form for the user
    my $durc;
    my $userID=$_[0];
    my $filename_server=$_[1];
    my $PG_COMMAND=qq{SELECT pdf, filename FROM durc WHERE uid=? order by creation_time DESC};

    my $database_name=getDatabaseName();
    my $db_username=getDatabaseUsername();
    my $db_pwd=getDatabasePwd();

    # connect to the database
    my $dbh = DBI->connect("DBI:Pg:dbname=$database_name", "$db_username", "$db_pwd")
       or die $DBI::errstr;


    my $sth = $dbh->prepare($PG_COMMAND)
      or die "Couldn't prepare statement: " . $dbh->errstr;


    $sth->execute( $userID ) or die "Can't execute SQL statement: $dbh::errstr\n";

    my @row2 = $sth->fetchrow_array;
    if( (scalar @row2) != 0 )
    {
        my $durc=($row2[0]);
        my $filenameUpload = $row2[1];

        my $filename_server2 = "/home2/cargoevo/public_html/tmp/$filenameUpload";

        #print "$filenameUpload\n";

        if( $filenameUpload )
        {
          $filename_server2 = "/home2/cargoevo/public_html/tmp/$filenameUpload";
          $filename_server = $filenameUpload;
        }
        else
        {
          $filename_server2 = "/home2/cargoevo/public_html/tmp/$filename_server";
        }

        # actually save file
        open(my $OUT, '>:raw', $filename_server2) or die "Unable to open: $filename_server";

        print $OUT $durc;
        close($OUT);
        return $filename_server;
    }
    else
    {
        $durc = undef;
        return $durc;
    }

    $sth->finish;
    $dbh->disconnect();
    return $filename_server;
}
1;
