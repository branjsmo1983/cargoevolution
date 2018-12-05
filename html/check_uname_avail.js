;(function($){
    $.fn.extend({
        donetyping: function(callback,timeout){
            timeout = timeout || 2e3; // 1 second default timeout
            var timeoutReference,
                doneTyping = function(el){
                    if (!timeoutReference) return;
                    timeoutReference = null;
                    callback.call(el);
                };
            return this.each(function(i,el){
                var $el = $(el);
                // Chrome Fix (Use keyup over keypress to detect backspace)
                // thank you @palerdot
                $el.is(':input') && $el.on('keyup keypress paste',function(e){
                    // This catches the backspace button in chrome, but also prevents
                    // the event from triggering too preemptively. Without this line,
                    // using tab/shift+tab will make the focused element fire the callback.
                    if (e.type=='keyup' && e.keyCode!=8) return;
                    
                    // Check if timeout has been set. If it has, "reset" the clock and
                    // start over again.
                    if (timeoutReference) clearTimeout(timeoutReference);
                    timeoutReference = setTimeout(function(){
                        // if we made it here, our timeout has elapsed. Fire the
                        // callback
                        doneTyping(el);
                    }, timeout);
                }).on('blur',function(){
                    // If we can, fire the event since we're leaving the field
                    doneTyping(el);
                });
            });
        }
    });
})(jQuery);

$(document).ready(function () {
    $("#username").donetyping(function(event) {
      // Get some values from elements on the page: 
        var username = document.getElementById("username").value; // get data
        // alert( username  );
        perlExecute(username);
     });
});

function perlExecute(username){
    $.ajax({
        type: 'GET',
        url: '/cgi-bin/check_uname_avail.pl?username='+username,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: { 'username': username },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
          alert("errorThrown: " + errorThrown + ", textStatus: " + textStatus );
          },
        success: function(data){
          if (data.error)
          {
             alert("Nome utente \"" +  data.username  + "\", non disponibile");
             document.getElementById('username').value = "";
          }
          else
          {
            // alert("Nome utente disponibile");
          }
        }
    });
};

