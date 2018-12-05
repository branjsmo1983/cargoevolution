$(document).ready(function(){


});

function setPrivacy ( value ){
  var sid=$('#sid').attr('value');
  $.ajax({
     type: "GET",
     url: "/cgi-bin/updatePrivacy.pl?privacy=" + value + "&sid="+sid, // URL of the Perl script
     contentType: "application/json; charset=utf-8",
     //dataType: "json",
     error: function(XMLHttpRequest, textStatus, errorThrown) {
             alert("Script was not successful");
      }, // error
     success: function(data){
        $("#userAlert").html("");
        }
   });
}

function setConditions ( value ){
  var sid=$('#sid').attr('value');
  $.ajax({
     type: "GET",
     url: "/cgi-bin/updateConditions.pl?conditions=" + value + "&sid="+sid, // URL of the Perl script
     contentType: "application/json; charset=utf-8",
     //dataType: "json",
     error: function(XMLHttpRequest, textStatus, errorThrown) {
             alert("Script was not successful");
      }, // error
      success: function(data){
         $("#userAlertConditions").html("");
         }
   });
}
