require "../cgi-bin/getNumUnreadMessagesMyChat.pl";
require "../cgi-bin/getNumUnreadMessagesChat.pl";
require "../cgi-bin/generateHTMLRefreshImage.pl";
require "../cgi-bin/getDemoAccountId.pl";

sub generateHTMLUserActionLinks
{
  my $sessionID= $_[0];

  my $session = new CGI::Session(undef, $sessionID, {Directory=>"/tmp"});
  my $uid = $session->param("username");

  my $demo_id = getDemoAccountId();

  my $num_my_unread_msgs = getNumUnreadMessagesMyChat( $sessionID );
  my $num_my_unread_msgs_string;

  if( $num_my_unread_msgs )
  {
     $num_my_unread_msgs_string = "($num_my_unread_msgs)";
  }
  else
  {
     $num_my_unread_msgs_string = "";
  }

  my $num_unread_msgs = getNumUnreadMessagesChat( $sessionID );
  my $num_unread_msgs_string;

  if( $num_unread_msgs )
  {
     $num_unread_msgs_string = "($num_unread_msgs)";
  }
  else
  {
     $num_unread_msgs_string = "";
  }

  my $unread_mesg_tot=$num_my_unread_msgs + $num_unread_msgs;
  my $unread_mesg_tot_str;
  if( $unread_mesg_tot )
  {
    $unread_mesg_tot_str = "($unread_mesg_tot)";
  }
  else
  {
    $unread_mesg_tot_str = "";
  }

  my $ref_tring = "<img src=\"/images/refresh3.png\" />";
  #print "<div class=\"row\">\n";
  print "<div class=\"col-md-2 col-sm-2 col-xs-2\">";
  print <<EOF;
  <nav>
  <ul>
EOF
   print "<hr/><li><a href=\"/cgi-bin/perlExecuteLogInSuccessful.pl?sid=$sessionID&fromLink=1\">Home $ref_tring</a></li>\n";
   print "<hr/><li><a href=\"/cgi-bin/selectUserMessages.pl?sid=$sessionID\">I Miei viaggi</a></li>\n";
   print "<hr/><li><a href=\"/cgi-bin/selectUserChats.pl?sid=$sessionID\">Chat $unread_mesg_tot_str</a></li>\n";
  # print "<hr/><li><a href=\"/cgi-bin/selectUserContactRequests.pl?sid=$sessionID\">Storico chat $num_unread_msgs_string</a></li>\n";

  if( $demo_id eq $uid )
  {
    print "<hr/><li><a>Offri merce &nbsp&nbsp</a></li>\n";
  }
  else
  {
      print "<hr/><li><a href=\"/cgi-bin/login_succ.pl?sid=$sessionID\">Offri merce &nbsp&nbsp</a></li>\n";
  }

   print "<hr/><li><a href=\"/cgi-bin/login_succ_view.pl?sid=$sessionID\">Cerca merce</a></li>\n";

   if( $demo_id eq $uid )
   {
     print "<hr/><li><a>Inserisci veicolo</a></li>\n";
   }
   else
   {
      print "<hr/><li><a href=\"/cgi-bin/insertTruck.pl?sid=$sessionID\">Inserisci veicolo</a></li>\n";
   }

   print "<hr/><li><a href=\"/guida.html?sid=$sessionID\">Guida</a></li>\n";
   print "<hr/><li><a href=\"/faq.html?sid=$sessionID\">F.A.Q.</a></li>\n";
   print "<hr/><li><a href=\"/glossario.html?sid=$sessionID\">Glossario</a></li>\n";
   print "<hr/><li style=\"background-size:140% 128% \"><a href=\"/fullcalendar.html?sid=$sessionID\">Calendario divieti di circolazione</a></li>";
   print "<hr/><li style=\"background-size:140% 128% \"><a href=\"/cgi-bin/generateHTMLMercatoQuick.pl?sid=$sessionID\">Vendita/Acquisto Mezzi</a></li>";
   print "<hr/><li style=\"background-size:140% 128% \"><a href=\"/cgi-bin/generateHTMLMercatinoQuick.pl?sid=$sessionID\">Offerta/Ricerca Personale</a></li>";
   print "<hr/><li style=\"background-size:140% 128% \"><a href=\"/cgi-bin/generateHTMLMercatoMezzi.pl?sid=$sessionID\">Vendita/Acquisto Mezzi</a></li>";
   print "<hr/><li style=\"background-size:140% 128% \"><a href=\"/cgi-bin/generateHTMLMercatino.pl?sid=$sessionID\">Offerta/Ricerca Personale</a></li><hr/>\n";
   print "\n</ul>\n</nav></div>\n";
   # add some hidden fields
   print "<input id=\"sid\" name=\"sid\" type=\"hidden\" value=\"$sid\">";
   print "<input id=\"num_msg\" name=\"num_msg\" type=\"hidden\" value=\"$unread_mesg_tot\">";
   #print "</div>\n";
}
1;
