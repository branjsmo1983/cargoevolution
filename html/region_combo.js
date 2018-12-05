$(document).ready(function(){
  var region_1   = document.getElementById("region").value;
  var province_1 = document.getElementById("province").value;
  // alert( "region = " + region_1 + ", province = " + province_1 );
  $.ajax({
    type: "GET",
    url: "/cgi-bin/generateHTMLRegion.pl?region=" + region_1 + "&province=" + province_1, // URL of the Perl script
    contentType: "text/html; charset=utf-8",
    dataType: "html",
    // send username and password as parameters to the Perl script
    // data: "username=" + username + "&password=" + password,
    // script call was *not* successful
    error: function(XMLHttpRequest, textStatus, errorThrown) {
      $('div#region_sel').text("responseText: " + XMLHttpRequest.responseText
        + ", textStatus: " + textStatus
        + ", errorThrown: " + errorThrown);
      $('div#region_sel').addClass("error");
    }, // error
    // script call was successful
    success: function(data){
      $('div#region_sel').html( data );

      $("#sel_reg").change(function(event){
      // Province combo
      var region = $('#sel_reg option:selected').attr('value');
      $.ajax({
        type: "GET",
        url: "/cgi-bin/generateHTMLProvince.pl", // URL of the Perl script
        contentType: "text/html; charset=utf-8",
        dataType: "html",
        data: "region=" + region,
        // script call was *not* successful
        error: function(XMLHttpRequest, textStatus, errorThrown) {
          $('div#province_sel').text("responseText: " + XMLHttpRequest.responseText
            + ", textStatus: " + textStatus
            + ", errorThrown: " + errorThrown);
          $('div#province_sel').addClass("error");
        }, // error
        // script call was successful
        success: function(data){
          $('div#province_sel').html( data );
        } // success
      }); // ajax
    }); // change event
    } // success
  }); // ajax

  if( region_1  )
  {
    $.ajax({
      type: "GET",
      url: "/cgi-bin/generateHTMLProvince.pl?region=" + region_1 + "&province=" + province_1, // URL of the Perl script
      contentType: "text/html; charset=utf-8",
      dataType: "html",
      // send username and password as parameters to the Perl script
      // data: "username=" + username + "&password=" + password,
      // script call was *not* successful
      error: function(XMLHttpRequest, textStatus, errorThrown) {
        $('div#province_sel').text("responseText: " + XMLHttpRequest.responseText
          + ", textStatus: " + textStatus
          + ", errorThrown: " + errorThrown);
        $('div#province_sel').addClass("error");
      }, // error
      // script call was successful
      success: function(data){
        $('div#province_sel').html( data );
      } // success
    }); // ajax    
  }

});
