
window.localStorage.MyLib = {}; // global Object container; don't use var
window.localStorage.MyLib.value = 0;
window.localStorage.MyLib.set_value = function(val) { MyLib.value = val; }

document.addEventListener('DOMContentLoaded', function ()
{

  if (Notification.permission !== "granted")
  {
    Notification.requestPermission();
  }

});

function notifyBrowser(title,desc,url)
{

  if (Notification.permission !== "granted")
  {
    Notification.requestPermission();
  }
  else
  {
      var notification = new Notification(title, {
      icon:'http://cargoevolution.com/images/logo2.png',
      body: desc,
      });
  }
}

window.onload = (function(){

   var sid = $('#sid').attr('value'); // get session id
   var num_unread_msg = $('#num_msg').attr('value');
   var message = $("#message").val();     // get text
   var num_messages = $.cookie("unread_msg");
   var intro_message = $.cookie("intro_msg");

   if( intro_message )
   {

   }
   else
   {
     var title2 ="cargoevolution";
     var desc2 ='Mantieni aperta la pagina di Cargoevolution per ricevere le notifiche web';
     var url2 ="www.cargoevolution.com/cgi-bin/perlExecuteLogInSuccessful.pl?sid=" + sid;
     notifyBrowser(title2,desc2,url2);
   }


   $.cookie("intro_msg", 1);

  if( num_messages !=  num_unread_msg && num_unread_msg != 0 && num_unread_msg)
  {
    var title ="cargoevolution";
    var desc ='Ci sono dei messaggi non letti (' + num_unread_msg +  ")";
    var url ="www.cargoevolution.com/cgi-bin/perlExecuteLogInSuccessful.pl?sid=" + sid;
    notifyBrowser(title,desc,url);

  }

  $.cookie("unread_msg", num_unread_msg);
   //alert( "Notify me: " + num_messages + ", " + num_unread_msg);
   window.localStorage.MyLib.value =  num_unread_msg ;
   return false;

}); // document
