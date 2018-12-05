
  $(document).ready(function(){
  $("form#sendForm").submit(function() { // loginForm is submitted
    var message =$("#message").val(); // get message
    var company = $('#company').attr('value'); // get company
    //alert('blog.js: ' + message  + ", " + company);

    if (message) { // value is not empty
      $.ajax({
        type: "GET",
        url: "/cgi-bin/insertblog.pl", // URL of the Perl script
        contentType: "application/json; charset=utf-8",
        // dataType: "json",
        // send message and company as parameters to the Perl script
        data: "message=" + message + "&company=" + company,
        // script call was *not* successful
        error: function(XMLHttpRequest, textStatus, errorThrown) {

        }, // error
        // script call was successful
        // data contains the JSON values returned by the Perl script
        success: function(data){
	$("#message").val("");
          if (data.error) { // script returned error
            { alert('Messaggio non inserito'); }

          } // if
          else { // login was successful
            $("div#listMessages").empty();

	    location.reload();
            //$('div#sendResult').text("data.success: " + data.success
            //  + ", data.userid: " + data.userid);

          } //else
        } // success
      }); // ajax
    } // if
    else {
      $('div#sendResult').text("Inserisci un messaggio pubblico");

    } // else
    $('div#sendResult').fadeIn();
    return false;
  });
});
