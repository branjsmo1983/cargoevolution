$( function() {
  //$( "input" ).checkboxradio();
var dialog, form;
var mid = $( "#mid" ).val();

function deleteMessage(  )
{
  //var res = $('input[name=radio]:checked', '#dia_form').val();
  var res2 = $('input[name=gender]:checked', '#dia_form').val()
  console.log('Yo: ' + mid + ' ' +  res2);
  dialog.dialog( "close" );
}

  dialog = $( "#dialog" ).dialog({
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
        "Procedi": deleteMessage,
        Cancel:  function(){var mid=  $( this ).dialog( "close" )}
      }
  });

  form = dialog.find( "form" ).on( "submit", function( event ) {
  event.preventDefault();
  deleteMessage( mid );
});

  $( "#opener" ).on( "click", function() {
  $( "#dialog" ).dialog( "open" );
  });
} );
