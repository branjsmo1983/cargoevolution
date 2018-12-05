function redirect (url) {
    var ua        = navigator.userAgent.toLowerCase(),
        isIE      = ua.indexOf('msie') !== -1,
        version   = parseInt(ua.substr(4, 2), 10);

    // Internet Explorer 8 and lower
    if (isIE && version < 9) {
        var link = document.createElement('a');
        link.href = url;
        document.body.appendChild(link);
        link.click();
    }

    // All other browsers can use the standard window.location.href (they don't lose HTTP_REFERER like Internet Explorer 8 & lower does)
    else { 
        window.location.href = url; 
    }
};

$(document).ready(function(){
  $("form#loginForm").submit(function() { // loginForm is submitted
    // var username = $('#username').attr('value'); // get username
    
    var username = document.getElementById("username").value;
    username = encodeURIComponent(username);
    // var password = $('#password').attr('value'); // get password
    var password = document.getElementById("password").value;
    password = encodeURIComponent(password);
    //alert(password);
    if (username && password) { // values are not empty
      $.ajax({
        type: "GET",
        url: "/cgi-bin/login.pl", // URL of the Perl script
         contentType: "application/json; charset=utf-8",
        //contentType: "text/html; charset=utf-8",
        dataType: "json",
        // send username and password as parameters to the Perl script
        data: "username=" + username + "&password=" + password,
        // script call was *not* successful
        error: function(XMLHttpRequest, textStatus, errorThrown) { 
          $('div#loginResult').text("responseText: " + XMLHttpRequest.responseText 
            + ", textStatus: " + textStatus 
            + ", errorThrown: " + errorThrown);
          $('div#loginResult').addClass("error");
        }, // error 
        // script call was successful 
        // data contains the JSON values returned by the Perl script
        success: function(data){
          if (data.error) { // script returned error
            $('div#loginResult').text("data.error: " + data.error);
            $('div#loginResult').addClass("error");
          } // if
          else { // login was successful
            $('form#loginForm').hide();
	    //$('div#loginResult').hide();
              //$('div#loginResult').text("data.success: " + data.success + ", data.userid: " + data.userid);
              // redirect here
              window.location.href = "/cgi-bin/perlExecuteLogInSuccessful.pl?sid=" + data.sid+ "&fromLink=1";
              perlExecuteLogInSuccessful(data.sid);
              //redirect( "/cgi-bin/login_succ.pl?username=" + data.userid );
              //$('div#loginResult').addClass("success");
          } //else
        } // success
      }); // ajax
    } // if
    else {
      $('div#loginResult').text("enter username and password");
      $('div#loginResult').addClass("error");
    } // else
    $('div#loginResult').fadeIn();
    return false;
  });
});

function perlExecuteLogInSuccessful(sid){
    
   $.ajax({
      type: 'POST',
      url: '/cgi-bin/perlExecuteLogInSuccessful.pl?sid='+sid,
      data: { 'sid': sid },
      success: function(res) {
      $('#MainBody').empty();
      document.getElementById("MainBody").innerHTML = res;
      // document.getElementById("deliveryRegionDiv").innerHTML=res;
      },
      error: function() {}
   }); // ajax
   }; // function

