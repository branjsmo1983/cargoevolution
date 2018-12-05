
function getUnreadMessages( ){

  var sid   = document.getElementById("sid").value;
  //alert('sid = ' + sid);
  $.ajax({
    type: "GET",
    url: "/cgi-bin/generateHTMLUnreadMessagesChatScript.pl?sid=" + sid , // URL of the Perl script
    contentType: "text/html; charset=utf-8",
    dataType: "html",
    // script call was *not* successful
    error: function(XMLHttpRequest, textStatus, errorThrown) {

    }, // error
    // script call was successful
    success: function(data){
      // alert('Success');
      $('div#new_messages').html( data );


    } // success
  }); // ajax
  //getUnreadMessagesUser();

}

function getUnreadMessagesUser( ){

  var sid   = document.getElementById("sid").value;
  //alert('sid = ' + sid);
  $.ajax({
    type: "GET",
    url: "/cgi-bin/generateHTMLUnreadMessagesMyChatScript.pl?sid=" + sid , // URL of the Perl script
    contentType: "text/html; charset=utf-8",
    dataType: "html",
    // script call was *not* successful
    error: function(XMLHttpRequest, textStatus, errorThrown) {

    }, // error
    // script call was successful
    success: function(data){
      // alert('Success');
      $('div#new_messages').append( data );

    } // success
  }); // ajax

}

$(document).ready( function(){setInterval(getUnreadMessages, 5000); getUnreadMessages(); } );
