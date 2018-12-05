use List::MoreUtils qw(uniq);

sub getUidsForChat{

  my $messageID = $_[0];
  my $sid= $_[1];

  my $session = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
  my $MyID = $session->param("username");

  my @uids;
  my $sth = getChatInsertion( $messageID );
  while (my @row = $sth->fetchrow_array) { 
     my $uid = $row[0];

     if( "$uid" ne "$MyID" )
     {
        push @uids, $uid;
     }

     
  }

  my @unique_uids = uniq @uids;
  # print "\@unique_uids = @unique_uids\n";
  # print "\$MyID = $MyID\n";

  return @unique_uids;
}
1;
