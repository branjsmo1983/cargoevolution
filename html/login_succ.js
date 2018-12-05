$(document).ready(function(){
  $("form#inputTrip").click(function() { // loginForm is submitted
    var date_of_loading1 = $('#date_of_loading1').attr('value'); // get date of loading
    //$('#myDateDiv').datepicker('setDate', ListDate[0]);

    if (date_of_loading1) {
	window.location.replace("/cgi-bin/login_succ.pl?date_of_loading1=" + date_of_loading1);

    } // if
    else {

    } // else

    return false;
  });
});

