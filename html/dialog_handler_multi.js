var count=0;

$(document).ready(function() {
    //$("#resultTable").show();
    $("#resultTable").fadeIn(2000);
  });

$(window).on('load',function() {
  // When the page has loaded
  // var table = $("#resultTable").fadeIn(2000);
  // console.log( table );
});

$( function() {
  //$( "input" ).checkboxradio();
var dialog, form;
var mid = $( "#mid_" +  count ).val();
var sid = $("#sid").val();
// console.log(mid);
// console.log(count);
// console.log(sid);
count = count  + 1;

function deleteMessage(  )
{
  //var res = $('input[name=radio]:checked', '#dia_form').val();
  var res2 = $('input[name=gender]:checked', '#dia_form_' + mid).val()
  // console.log('Yo: ' + mid + ' ' +  res2);
  dialog.dialog( "close" );
  var args = "?messageID=" + mid + "&sid=" + sid
  if( res2 == "err" )
  {
      // console.log('Non concluso: ' + mid);
      args = args + "&type=-1";
  }
  else {
    // console.log('Business concluso: ' + mid);
    if( res2 == "cargo" )
    {
        args = args + "&type=-2";
    }
    else {
        args = args + "&type=-3";
    }

  }

  $.ajax({
      type: 'GET',
      url: '/cgi-bin/eraseContact.pl'+ args,
      contentType: "text/html; charset=utf-8",
      dataType: "html",
      // data: { 'multi': 'False', 'sid' : sid, 'ContactMessageID' : ContactMessageID, 'chatCombo' : chat_index },
      success: function(res) {
      // console.log(args);
      // console.log( res );
      window.location = "/cgi-bin/selectUserMessages.pl?sid=" + sid;
      return false;
      //document.write(res);
      },
      error: function() { alert('Sing error');}
  });

}

  dialog = $( "#dialog_" + mid ).dialog({
    autoOpen: false,
    show: {
      effect: "blind",
      duration: 1000
    },
    hide: {
      effect: "explode",
      duration: 1000
    },
    modal: true,
    buttons: {
        "OK": deleteMessage,
        Annulla:  function(){var mid=  $( this ).dialog( "close" )}
      }
  });

  form = dialog.find( "form" ).on( "submit", function( event ) {
  event.preventDefault();
  deleteMessage( mid );
});

  //$( "#opener" ).on( "click", function() { $( "#dialog" ).dialog( "open" ); });
  $( "#opener_" + mid ).on( "click", function() { $( "#dialog_" + mid ).dialog( "open" ); });
} );
