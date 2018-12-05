var count=0;

$(document).ready(function() {
    // $("#resultTable").fadeIn(2000);
    var dialog, form;
    var sid = $("#sid").val();
    dialog = $( "#dialog_conditions" ).dialog({
        autoOpen: false,
        closeOnEscape: false,
        open: function(event, ui) {
          $(".ui-dialog-titlebar-close", ui.dialog | ui).hide();
        },
        show: {
          effect: "blind",
          duration: 1000
        },
        hide: {
          effect: "fade",
          duration: 1000
        },
        modal: true,
        buttons: {
            "Accetto": function() {
                $(this).dialog('close');
                //console.log('sid', sid);
                setPrivacy(1);
                setConditions(1);
            },
            Annulla:  function(){window.location.replace("http://cargoevolution.com");
}
          }
      });

      form = dialog.find( "form" ).on( "submit", function( event ) {
      event.preventDefault();
      deleteMessage( mid );
    });

      //$( "#opener" ).on( "click", function() { $( "#dialog" ).dialog( "open" ); });
      $( "#dialog_conditions" ).dialog( "open" );
    } );
