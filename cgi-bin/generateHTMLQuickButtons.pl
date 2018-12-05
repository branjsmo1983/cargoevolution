use cPanelUserConfig;
use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use Path::Class;

require "../cgi-bin/generateHTMLUnreadMessagesMyChat.pl";
require "../cgi-bin/generateHTMLUnreadMessagesChat.pl";
require "../cgi-bin/getDemoAccountId.pl";

sub generateHTMLQuickButtons
{
  my $insert_goods = $_[0];
  my $search_vehicle = $_[1];
  my $sid = $_[2];
  my $chat = $_[3];
  my $insertTruck = $_[4];

  my $usession = new CGI::Session(undef, $sid, {Directory=>"/tmp"});
  # get user ID from user session
  my $uid = $usession->param('username');
  my $demo_id = getDemoAccountId();

  print "<div class=\"msgContainer\" id=\"new_messages\" name=\"new_messages\">\n";
  #generateHTMLUnreadMessagesMyChat( $sid );
  #generateHTMLUnreadMessagesChat( $sid );
  print "</div>\n";

print <<EOF;

      <div class="row btnUp">
        <div class="col-md-4 col-md-offset-1 col-sm-5   col-xs-5 btnUpLeft">
EOF

  if( $demo_id eq $uid )
  {
    print "<a><img class=\"image\" src=\"/img/pallet.png\"  style=\"background-color: rgba(100,100,100,0.8)\" height=\"150\" width=\"130\"><center><figcaption>Offri merce</figcaption></center></a>";
  }
  else
  {
    print "<a href=\"$insert_goods\"><img class=\"image\" src=\"/img/pallet.png\" height=\"150\" width=\"130\"><center><figcaption>Offri merce</figcaption></center></a>";
  }
  #print "<div class=\"imgContainer\">&nbsp&nbsp </div>";

print <<EOF;
        </div>
        <div class="col-md-4 col-md-offset-1 col-sm-5 col-sm-offset-1  col-xs-5 btnUpRight">
EOF

  #print "<div class=\"imgContainer\"><img class=\"image\" src=\"/img/blankSpace.png\" /> </div>";
  print "<a href=\"$search_vehicle\"><img class=\"image\" src=\"/img/bancale.png\" height=\"150\" width=\"150\"><center><figcaption>Cerca merce</figcaption></center></a>";
  #print "<div class=\"imgContainer\">&nbsp&nbsp </div>";

print <<EOF;
         </div>

      </div>
      <div class="row btnDown">
          <div class="col-md-4 col-md-offset-1 col-sm-5  col-xs-5 btnDownLeft">
EOF

    #print "<div class=\"imgContainer\"><img class=\"image\" src=\"/img/blankSpace.png\" /> </div>";
    print "<a href=\"$chat\"><img class=\"image\" src=\"/img/chat.png\" height=\"150\" width=\"130\"><center><figcaption>Chat</figcaption></center></a>";
    #print "<div class=\"imgContainer\">&nbsp&nbsp </div>";

print <<EOF;
        </div>
        <div class="col-md-4 col-md-offset-1 col-sm-5 col-sm-offset-1  col-xs-5 btnDownRight">
EOF

    #print "<div class=\"imgContainer\"><img class=\"image\" src=\"/img/blankSpace.png\" /> </div>";
    if( $demo_id eq $uid )
    {
      print "<div class=\"overlay_dis\"><a><img class=\"image\" style=\"background-color: rgba(100,100,100,0.8)\" src=\"/img/camion.png\" height=\"150\" width=\"150\"><center><figcaption>Inserisci veicolo</figcaption></center></a></div>";
    }
    else
    {
      print "<a href=\"$insertTruck\"><img class=\"image\" src=\"/img/camion.png\" height=\"150\" width=\"150\"><center><figcaption>Inserisci veicolo</figcaption></center></a>";
    }
    #print "<div class=\"imgContainer\">&nbsp&nbsp </div>";

    # #print "<div class=\"imgContainer\"><img class=\"image\" src=\"/img/blankSpace.png\" /> </div>";
    # print "<a href=\"/guida.html?sid=$sid\"><img class=\"image\" src=\"/img/manual.png\" height=\"236\" width=\"231\"><center><figcaption>Guida</figcaption></a>";
    # #print "<div class=\"imgContainer\">&nbsp&nbsp </div>";

  print <<EOF;
        </div>
      </div>
      <div class="row">
       <hr/>
        <div class="col-md-4 col-sm-12 col-xs-12">
         
         <a href=\"http://www.euromotori-daf.it\" target="_blank" > <img src=\"/img/daf.jpeg\" height="210" width="340"></a>
        </div>
       
      </div>
      <div class="row">
      <hr/>
        <div class="col-md-4 col-sm-6 col-xs-12">
         <a href=\"http://www.agossrl.com/\" target="_blank" > <img src=\"/images/LogoAgos.jpg\" height="105" width="340"></a>
        </div>
      </div>
         <div class="row">
         <hr/>

        <div class="col-md-4 col-sm-6 col-xs-12">
      
         <a href=\"http://www.recaffe.com/\" target="_blank" > <img src=\"/images/recaffe.png\" height="105" width="340"></a>
        </div>
      </div>
      <div class="row">
        <div class="col-md-12 col-sm-12 col-xs-12">
          <hr/> Si raccomanda di allegare copia del DURC aggiornata nella sezione <a href="updateAccount.pl?sid=$sid"> Gestisci account</a>
        </div>
      </div>
      <svg width="0" height="0">
        <defs>
          <clipPath id="clip1">
              <path
             d="M 0 207.918 L 146.463 206.956 L 146.967 141.224 L 150.742 141.056 L 150.574 149.037 L 158.387 146.659 L 158.098 136.73 L 161.464 136.609 L 161.705 146.659 L 172.668 146.538 L 172.668 131.921 L 176.995 132.209 L 176.659 146.659 L 184.088 147.068 L 183.968 141.729 L 180.434 137.402 L 185.459 134.661 L 188.872 128.145 L 200.076 120.501 L 211.302 126.439 L 216.615 140.216 L 213.323 141.513 L 213.323 146.538 L 225.657 146.081 L 225.2 137.402 L 227.41 137.113 L 228.277 147.982 L 232.052 149.279 L 231.595 141.513 L 230.681 137.402 L 230.681 124.155 L 235.249 112.735 L 244.385 100.858 L 256.719 91.2658 L 269.966 85.3274 L 275.904 83.5003 L 273.163 78.4755 L 274.702 72.7999 L 276.865 63.2333 L 279.558 70.71 L 279.485 75.6614 L 280.015 84.4873 L 292.806 88.9818 L 304.346 96.6266 L 312.327 103.983 L 319.804 113.817 L 323.868 128.266 L 325.238 137.402 L 322.954 141.513 L 322.954 146.538 L 326.152 145.168 L 326.152 135.118 L 330.263 134.661 L 329.806 146.538 L 342.596 146.538 L 342.596 141.056 L 335.744 140.143 L 341.683 130.55 L 346.251 123.241 L 354.93 117.76 L 364.979 125.069 L 367.72 134.204 L 374.572 136.488 L 371.831 141.97 L 373.201 145.624 L 378.226 145.624 L 378.226 139.229 L 375.942 135.118 L 380.053 130.093 L 381.881 136.488 L 381.881 145.624 L 392.387 146.081 L 392.387 140.6 L 394.671 135.575 L 396.498 141.97 L 396.041 146.995 L 404.095 149.494 L 403.35 139.639 L 406.642 139.35 L 407.004 205.921 L 434.412 205.921 L 437.609 192.217 L 446.745 193.588 L 449.029 204.094 L 567.555 205.008 L 567.796 425.491 L 0.288769 425.659 Z"/>
          </clipPath>
          <clipPath id="clip2">
             <path
             d="M 14.8492 10.0868 L 80.6102 35.5426 L 125.865 6.55125 L 152.028 36.9568 L 199.404 8.67257 L 255.973 41.9066 L 305.47 3.72283 L 362.039 36.2497 L 386.787 8.67257 L 454.67 44.0279 L 477.297 9.37968 L 502.753 27.7645 L 555.079 7.96547 L 565.685 32.0071 L 530.33 98.4751 L 567.1 153.629 L 523.259 190.399 L 563.564 254.039 L 528.916 280.909 L 567.1 352.326 L 543.058 418.087 L 501.339 388.389 L 441.235 423.037 L 414.365 391.217 L 325.976 420.916 L 272.236 393.339 L 248.902 420.916 L 178.898 389.803 L 108.894 420.209 L 65.7609 392.632 L 35.3553 420.916 L 0.707107 391.217 L 24.7487 318.385 L 2.82843 266.767 L 29.6985 245.553 L 1.41421 191.813 L 29.6985 123.224 L 3.53553 82.2117 L 26.8701 46.8563 Z"/>
          </clipPath>
          <clipPath id="clip3">
             <rect width="568" height="426" rx="85.2" ry="85.2"/>
          </clipPath>
          <clipPath id="clip4">
              <ellipse cx="284" cy="213" rx="284" ry="213"/>
          </clipPath>
          <filter id="filter2">
            <feGaussianBlur stdDeviation="10"/>
          </filter>
          <filter id="filter">
            <feGaussianBlur stdDeviation="0.03"/>
          </filter>
          <filter id="filter2">
            <feGaussianBlur stdDeviation="5"/>
          </filter>
          <linearGradient id="gradient" x1="0" y1="00%" x2 ="0" y2="100%">
            <stop stop-color="black" offset="0"/>
            <stop stop-color="white" offset="1"/>
          </linearGradient>
          <mask id="masking2" maskUnits="objectBoundingBox" maskContentUnits="objectBoundingBox">
            <rect y="0.3" width="1" height=".7" fill="url(#gradient)" />
            <circle cx=".5" cy=".5" r=".35" fill="white" />
          </mask>
          <clipPath id="clipping4">
            <polygon points="0 0, 20 20, 40 0, 60 20, 80 0, 100 20, 120 0, 140 20, 160 0, 180 20, 200 0, 220 20, 240 0, 255 0, 255 300, 240 300, 220 280, 200 300, 180 280, 160 300, 140 280, 120 300, 100 280, 80 300, 60 280, 40 300, 20 280, 0 300"/>
          </clipPath>
          <clipPath id="clipping5" clipPathUnits="objectBoundingBox">
            <polygon points="1.00 .50,.8470057014808336 .545684167277018,.910518476172854 .6099980941685713,.8233578363789503 .6339392013277814,.9330127018922194 .75,.7776736691019323 .7130665001530522,.8005203820042827 .8005203820042827,.7130665001530522 .7776736691019323,.75 .9330127018922192,.6339392013277814 .8233578363789503,.6099980941685714 .910518476172854,.5456841672770181 .8470057014808336,.50 1.00,.454315832722982 .8470057014808336,.39000190583142874 .910518476172854,.36606079867221865 .8233578363789505,.2500000000000001 .9330127018922194,.28693349984694787 .7776736691019323,.19947961799571733 .8005203820042827,.2223263308980677 .7130665001530522,.06698729810778076 .7500000000000001,.17664216362104966 .6339392013277815,.08948152382714603 .6099980941685715,.15299429851916635 .54568416727701816,0 .5000000000000001,.15299429851916635 .45431583272298205,.0894815238271459 .3900019058314288,.1766421636210496 .3660607986722188,.06698729810778062 .25000000000000014,.2223263308980676 .28693349984694787,.19947961799571715 .19947961799571747,.2869334998469477 .22232633089806775,.2499999999999998 .06698729810778083,.3660607986722184 .17664216362104973,.3900019058314284 .08948152382714603,.4543158327229816 .15299429851916642,.4999999999999999 0,.54568416727701795 .15299429851916635,.6099980941685711 .0894815238271459,.6339392013277812 .1766421636210496,.7499999999999997 .066987298107780475,.713066500153052 .2223263308980675,.8005203820042826 .19947961799571722,.7776736691019323 .2869334998469477,.9330127018922192 .2499999999999998,.8233578363789502 .3660607986722184,.910518476172854 .3900019058314283,.8470057014808336 .4543158327229816"/>
          </clipPath>
        </defs>
      </svg>
EOF


}
1;
