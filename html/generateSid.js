$(document).ready(function(){

      $.ajax({
        type: "GET",
        url: "/cgi-bin/generateTempSid.pl", // URL of the Perl script
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        // send username and password as parameters to the Perl script
        data: "username=guest",
        // script call was *not* successful
        error: function(XMLHttpRequest, textStatus, errorThrown) { 
             //alert('Error');
        }, // error 
        // script call was successful 
        // data contains the JSON values returned by the Perl script
        success: function(data){
          if (data.error) { // script returned error
             //alert('no data');
          } // if
          else { // sid generation was successfull
             //alert('success:' + data.sid);
             $('div#sid_field').empty();
             $('div#sid_field').html('<input type="hidden" name="sid" id="sid" value="' + data.sid +'" />');
          } //else
        } // success
      }); // ajax

    return false;
});
