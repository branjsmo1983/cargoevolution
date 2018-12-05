var ref_interval_timer=0;
var delta_time=4000;

function perlExecuteChatUpdateTableSingle(){

    var args;
    var sid = $('#sid').attr('value'); // get session id
    var ContactMessageID = $('#ContactMessageID').attr('value'); // get ContactMessageID
    var chat_index;
    
    args = "?sid=" + sid + "&ContactMessageID=" + ContactMessageID;
 
    
    // alert (args);

    $.ajax({
        type: 'POST',
        url: '/cgi-bin/refreshChat.pl'+ args,
        data: { 'multi': 'False', 'sid' : sid, 'ContactMessageID' : ContactMessageID, 'chatCombo' : chat_index },
        success: function(res) {
        $('#ChatTable').empty();
        document.getElementById("ChatTable").innerHTML=res;
        return false;
        //document.write(res);
        },
        error: function() { alert('Sing error');}
    });
};

function perlExecuteChatUpdateTableMulti(){

    var args;
    var sid = $('#sid').attr('value'); // get session id
    var ContactMessageID = $('#ContactMessageID').attr('value'); // get ContactMessageID
    var chat_index; 

    chat_index = $('#chat_index').attr('value'); // get chat_index
    args = "?sid=" + sid + "&ContactMessageID=" + ContactMessageID + "&chatCombo=" + chat_index;

    // alert (args);

    $.ajax({
        type: 'POST',
        url: '/cgi-bin/refreshChat.pl'+ args,
        data: { 'multi': 'True', 'sid' : sid, 'ContactMessageID' : ContactMessageID, 'chatCombo' : chat_index },
        success: function(res) {
        $('#ChatTable').empty();
        document.getElementById("ChatTable").innerHTML=res;
        return false;
        //document.write(res);
        },
        error: function() { alert('Multi error'); }
    });
};

function perlExecuteChatUpdateTable(multi){

    var args;
    var sid = $('#sid').attr('value'); // get session id
    var ContactMessageID = $('#ContactMessageID').attr('value'); // get ContactMessageID
    var chat_index;
    
    if( multi == "True" )
    {
       chat_index = $('#chat_index').attr('value'); // get chat_index
       args = "?sid=" + sid + "&ContactMessageID=" + ContactMessageID + "&chatCombo=" + chat_index;
    }
    else
    {
       args = "?sid=" + sid + "&ContactMessageID=" + ContactMessageID;
    }
    
    // alert (args);

    $.ajax({
        type: 'POST',
        url: '/cgi-bin/refreshChat.pl'+ args,
        data: { 'multi': multi, 'sid' : sid, 'ContactMessageID' : ContactMessageID, 'chatCombo' : chat_index },
        success: function(res) {
        $('#ChatTable').empty();
        document.getElementById("ChatTable").innerHTML=res;
        return false;
        //document.write(res);
        },
        error: function() {}
    });
};

function clearTimeout (  ){
   clearTimeout( ref_interval_timer );
   alert("Timeout cleared");
}



$(document).ready(function(){
   //WriteMsg.onkeyup = clearTimeout();
   $("form#ContactChatForm").submit(function() {
   var sid = $('#sid').attr('value'); // get session id
   var ctext = $("#ctext").val();     // get text
   //alert( "ctext = " + ctext );
   var ContactMessageID = $('#ContactMessageID').attr('value'); // get ContactMessageID

   var multi_exists = !!document.getElementById("multi");
   var multi;
   var chat_index;
   var data_json;

   // clean text area
   document.getElementById("ctext").value = "";

   if( multi_exists )
   {
      ref_interval_timer = setInterval ( function() { perlExecuteChatUpdateTable("True"); }, delta_time );
      multi = $('#multi').attr('value'); // get multi
      chat_index = $('#chat_index').attr('value'); // get chat_index
      data_json = "sid=" + sid + "&ctext=" + ctext + "&multi=" + multi + "&chat_index=" + chat_index + "&ContactMessageID=" + ContactMessageID + "&chatCombo=" + chat_index;
      //alert("Multi");
   }
   else
   {
      ref_interval_timer = setInterval ( function() { perlExecuteChatUpdateTable("False"); }, delta_time );
      data_json = "sid=" + sid + "&ctext=" + ctext + "&ContactMessageID=" + ContactMessageID;
      //alert("Single");
   }


   $.ajax({
      type: "GET",
      url: "/cgi-bin/insertChatText.pl", // URL of the Perl script
      contentType: "application/json; charset=utf-8",
      //dataType: "json",
      data: data_json,
      error: function(XMLHttpRequest, textStatus, errorThrown) { 
              //alert("Script was not successful");
	     }, // error
      success: function(data){
		//alert("Success");

		if( multi_exists )
		{
		   //window.location="/cgi-bin/contactUserCombo.pl" + "?sid=" + sid + "&ContactMessageID=" + ContactMessageID + "&chatCombo=" + chat_index+ "#WriteMsg";
		   //location.reload(true);
                   perlExecuteChatUpdateTable("True");
		}
		else
		{
		   //window.location="/cgi-bin/contactUser.pl" + "?sid=" + sid + "&ContactMessageID=" + ContactMessageID + "#WriteMsg";
		   //location.reload(true);
                   perlExecuteChatUpdateTable("False");
		}
             }  // success
   }); // ajax
   return false;
   }); // form function
}); // document






