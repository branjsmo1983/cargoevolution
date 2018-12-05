function setDocsStatus(uid, status){
  var args = "uid=" + uid + "&doc_stat=" + status;
  $.ajax({
    type: "GET",
    url: "/cgi-bin/setDocsStatus.pl"+"?"+args, // URL of the Perl script
    contentType: "application/json; charset=utf-8",
    data: args,
    // script call was *not* successful
    error: function(XMLHttpRequest, textStatus, errorThrown) {

    }, // error
    success: function(data){
      if (data.error) { // script returned error
        alert('ARGH');
      } // if
      else { //success
        alert('Setting Doc Status to: ' + status);
        // console.log('uid: ', uid);
        // console.log('status: ', status);
      } //else
    } // success
  }); // ajax
}
