$(document).ready(function(){
  $("form#mercatinoForm").submit(function() { // loginForm is submitted
    var message =$("#message").val(); // get message
    var company = $('#company').attr('value'); // get company
    var name = $("#name").val();//get name
    var email = $("#email").val();
    var tel = $("#phone").val(); //get telephone number
    var form = $('#js-select2').val() // get form type number
    var work = ""; //get work type
    if($("#radio1").is(":checked") ){
	work = $("#radio1").attr('value');
	} else if($("#radio2").is(":checked") ){
	work = $("#radio2").attr('value');
	} else if($("#radio3").is(":checked") ){
	work = $("#radio3").attr('value');
	} else if($("#radio4").is(":checked") ){
	work = $("#radio4").attr('value');
	} else if($("#radio5").is(":checked") ){
	work = $("#radio5").attr('value');
	} else if($("#radio6").is(":checked") ){
	work = $("#radio6").attr('value');
	} 
    
    alert('valori: messaggio ' + message  + " ,company " + company+ " ,name " + name+ " ,tel " + tel+ " ,form " + form+ " ,work " + work + " email " + email);

    if (message) { // value is not empty
      $.ajax({
        type: "GET",
        url: "/cgi-bin/insertMercatino.pl", // URL of the Perl script
        contentType: "application/json; charset=utf-8",
        //dataType: "json",
	//async: false,
    	//cache: false,
        // send message and company as parameters to the Perl script
	
       	data: "message=" + message + "&company=" + company+ "&name=" + name+ "&tel=" + tel+ "&form=" + form+ "&work=" + work+ "&email=" + email,
        // script call was *not* successful
        error: function(XMLHttpRequest, textStatus, errorThrown) {
			alert('Errore :'+ errorThrown +' textStatus :' + textStatus + ' XMLHttpRequest: ' + XMLHttpRequest);
        }, // error
        // script call was successful
        // data contains the JSON values returned by the Perl script
        success: function(data){
	$("#message").val("");
          if (data.error) { // script returned error
            { alert('Messaggio non inserito'); }

          } // if
          else { // login was successful
           alert('Messaggio inserito correttamente');

	    location.reload();
            //$('div#sendResult').text("data.success: " + data.success
            //  + ", data.userid: " + data.userid);

          } //else
        } // success
      }); // ajax
    } // if
    else {
       alert('Non sono entrato nell IF');
    } // else
    //$('div#mercatinoForm').fadeIn();
    return false;
  });
});
