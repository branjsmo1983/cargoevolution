// $("#selRegions").html("");
function resetRegionDiv()
{
  $("#mapRegions").html("");
}

function forceUnselectRegions( image )
{
  $('area.vaosta').mapster('deselect');
  $('area.piemonte').mapster('deselect');
  $('area.lombardia').mapster('deselect');
  $('area.trentino').mapster('deselect');
  $('area.veneto').mapster('deselect');
  $('area.friuli').mapster('deselect');
  $('area.liguria').mapster('deselect');
  $('area.emilia').mapster('deselect');
  $('area.toscana').mapster('deselect');
  $('area.marche').mapster('deselect');
  $('area.umbria').mapster('deselect');
  $('area.lazio').mapster('deselect');
  $('area.abruzzo').mapster('deselect');
  $('area.molise').mapster('deselect');
  $('area.campania').mapster('deselect');
  $('area.puglia').mapster('deselect');
  $('area.basilicata').mapster('deselect');
  $('area.calabria').mapster('deselect');
  $('area.sicilia').mapster('deselect');
  $('area.sardegna').mapster('deselect');
}

function refreshSelRegions ( sid, image ){
  // inhibit click


  $("#selRegions").html("");
  var tmpStr='<div><p>Regioni selezionate:</p></div>';
  $.ajax({
     type: "GET",
     url: "/cgi-bin/getUserRegions.pl?sid="+sid, // URL of the Perl script
     contentType: "application/json; charset=utf-8",
     //dataType: "json",
     error: function(XMLHttpRequest, textStatus, errorThrown) {
             //alert("Script was not successful");
      }, // error
     success: function(data){ //console.log( data  );
       forceUnselectRegions( image );
       for (var key in data) {
          if (data.hasOwnProperty(key)) {
              var val = data[key];
              //console.log(val);
              switch(val) {
                case 'Valle Aosta':
                   $('area.vaosta').mapster('set',true);
                  // image.mapster('highlight', true, 'vaosta');
                break;
                case 'Piemonte':
                  $('area.piemonte').mapster('set',true);
                  //image.mapster('highlight', true, 'piemonte');

                break;
                case 'Lombardia':
                  $('area.lombardia').mapster('set',true);
                  //image.mapster('highlight', true, 'lombardia');

                break;
                case 'Trentino-Alto Adige':
                  $('area.trentino').mapster('set',true);
                  // image.mapster('highlight', true, 'trentino');

                break;
                case 'Veneto':
                  $('area.veneto').mapster('set',true);
                  // image.mapster('highlight', true, 'veneto');

                break;
                case 'Friuli Venezia Giulia':
                  $('area.friuli').mapster('set',true);
                  // image.mapster('highlight', true, 'friuli');

                break;
                case 'Liguria':
                  $('area.liguria').mapster('set',true);
                break;
                case 'Emilia Romagna':
                  $('area.emilia').mapster('set',true);
                break;
                case 'Toscana':
                  $('area.toscana').mapster('set',true);
                break;
                case 'Marche':
                  $('area.marche').mapster('set',true);
                break;
                case 'Umbria':
                  $('area.umbria').mapster('set',true);
                break;
                case 'Lazio':
                  $('area.lazio').mapster('set',true);
                break;
                case 'Abruzzo':
                  $('area.abruzzo').mapster('set',true);
                break;
                case 'Molise':
                  $('area.molise').mapster('set',true);
                break;
                case 'Campania':
                  $('area.campania').mapster('set',true);
                break;
                case 'Puglia':
                  $('area.puglia').mapster('set',true);
                break;
                case 'Basilicata':
                  $('area.basilicata').mapster('set',true);
                break;
                case 'Calabria':
                  $('area.calabria').mapster('set',true);
                break;
                case 'Sicilia':
                  $('area.sicilia').mapster('set',true);
                break;
                case 'Sardegna':
                  $('area.sardegna').mapster('set',true);
                break;
                default:

              }
              //$("#selRegions").append('<div>' + val + '</div>');
              tmpStr = tmpStr + '<div>' + val + '</div>';
          }

        }
        //
        $("#selRegions").html(tmpStr);
      }
   });
}

$(document).ready(function(){
  var sid=$('#sid').attr('value');
  var image = $('#mappaitalia');

  image.mapster(
    {
        fillOpacity: 0.4,
        fillColor: "d42e16",
        stroke: true,
        strokeColor: "3320FF",
        strokeOpacity: 0.8,
        strokeWidth: 4,
        singleSelect: false,
        mapKey: 'name',
        listKey: 'name'
    });
  refreshSelRegions(sid, image);
  $(".vaosta").on("click", function(e){
      e.preventDefault();
      $.ajax({
         type: "GET",
         url: "/cgi-bin/updateUserRegions.pl?region=19&sid="+sid, // URL of the Perl script
         contentType: "application/json; charset=utf-8",
         //dataType: "json",
         error: function(XMLHttpRequest, textStatus, errorThrown) {
                 //alert("Script was not successful");
          }, // error
         success: function(data){ refreshSelRegions(sid, image); }
       });
  });

  $(".piemonte").on("click", function(e){
      e.preventDefault();
      ////alert('Piemonte');
      $.ajax({
         type: "GET",
         url: "/cgi-bin/updateUserRegions.pl?region=12&sid="+sid, // URL of the Perl script
         contentType: "application/json; charset=utf-8",
         //dataType: "json",
         error: function(XMLHttpRequest, textStatus, errorThrown) {
                 //alert("Script was not successful");
          }, // error
         success: function(data){ refreshSelRegions(sid, image); }
       });
  });

  $(".lombardia").on("click", function(e){
      e.preventDefault();
      ////alert('Lombardia');
      $.ajax({
         type: "GET",
         url: "/cgi-bin/updateUserRegions.pl?region=9&sid="+sid, // URL of the Perl script
         contentType: "application/json; charset=utf-8",
         //dataType: "json",
         error: function(XMLHttpRequest, textStatus, errorThrown) {
                 //alert("Script was not successful");
          }, // error
         success: function(data){ refreshSelRegions(sid, image); }
       });
  });

  $(".trentino").on("click", function(e){
      e.preventDefault();
      ////alert('Trentino');
      $.ajax({
         type: "GET",
         url: "/cgi-bin/updateUserRegions.pl?region=17&sid="+sid, // URL of the Perl script
         contentType: "application/json; charset=utf-8",
         //dataType: "json",
         error: function(XMLHttpRequest, textStatus, errorThrown) {
                 //alert("Script was not successful");
          }, // error
         success: function(data){ refreshSelRegions(sid, image); }
       });
  });

  $(".veneto").on("click", function(e){
      e.preventDefault();
      ////alert('Veneto');
      $.ajax({
         type: "GET",
         url: "/cgi-bin/updateUserRegions.pl?region=20&sid="+sid, // URL of the Perl script
         contentType: "application/json; charset=utf-8",
         //dataType: "json",
         error: function(XMLHttpRequest, textStatus, errorThrown) {
                 //alert("Script was not successful");
          }, // error
         success: function(data){ refreshSelRegions(sid, image); }
       });
  });

  $(".friuli").on("click", function(e){
      e.preventDefault();
      ////alert('Friuli Venezia Giulia');
      $.ajax({
         type: "GET",
         url: "/cgi-bin/updateUserRegions.pl?region=6&sid="+sid, // URL of the Perl script
         contentType: "application/json; charset=utf-8",
         //dataType: "json",
         error: function(XMLHttpRequest, textStatus, errorThrown) {
                 //alert("Script was not successful");
          }, // error
         success: function(data){ refreshSelRegions(sid, image); }
       });
  });

  $(".liguria").on("click", function(e){
      e.preventDefault();
      ////alert('Liguria');
      $.ajax({
         type: "GET",
         url: "/cgi-bin/updateUserRegions.pl?region=8&sid="+sid, // URL of the Perl script
         contentType: "application/json; charset=utf-8",
         //dataType: "json",
         error: function(XMLHttpRequest, textStatus, errorThrown) {
                 //alert("Script was not successful");
          }, // error
         success: function(data){ refreshSelRegions(sid, image); }
       });
  });

  $(".emilia").on("click", function(e){
      e.preventDefault();
      ////alert('Emilia Romagna');
      $.ajax({
         type: "GET",
         url: "/cgi-bin/updateUserRegions.pl?region=5&sid="+sid, // URL of the Perl script
         contentType: "application/json; charset=utf-8",
         //dataType: "json",
         error: function(XMLHttpRequest, textStatus, errorThrown) {
                 //alert("Script was not successful");
          }, // error
         success: function(data){ refreshSelRegions(sid, image); }
       });
  });

  $(".toscana").on("click", function(e){
      e.preventDefault();
      ////alert('Toscana');
      $.ajax({
         type: "GET",
         url: "/cgi-bin/updateUserRegions.pl?region=16&sid="+sid, // URL of the Perl script
         contentType: "application/json; charset=utf-8",
         //dataType: "json",
         error: function(XMLHttpRequest, textStatus, errorThrown) {
                 //alert("Script was not successful");
          }, // error
         success: function(data){ refreshSelRegions(sid, image); }
       });
  });

  $(".marche").on("click", function(e){
      e.preventDefault();
      ////alert('Marche');
      $.ajax({
         type: "GET",
         url: "/cgi-bin/updateUserRegions.pl?region=10&sid="+sid, // URL of the Perl script
         contentType: "application/json; charset=utf-8",
         //dataType: "json",
         error: function(XMLHttpRequest, textStatus, errorThrown) {
                 //alert("Script was not successful");
          }, // error
         success: function(data){ refreshSelRegions(sid, image); }
       });
  });

  $(".umbria").on("click", function(e){
      e.preventDefault();
      ////alert('Umbria');
      $.ajax({
         type: "GET",
         url: "/cgi-bin/updateUserRegions.pl?region=18&sid="+sid, // URL of the Perl script
         contentType: "application/json; charset=utf-8",
         //dataType: "json",
         error: function(XMLHttpRequest, textStatus, errorThrown) {
                 //alert("Script was not successful");
          }, // error
         success: function(data){ refreshSelRegions(sid, image); }
       });
  });

  $(".lazio").on("click", function(e){
      e.preventDefault();
      ////alert('Lazio');
      $.ajax({
         type: "GET",
         url: "/cgi-bin/updateUserRegions.pl?region=7&sid="+sid, // URL of the Perl script
         contentType: "application/json; charset=utf-8",
         //dataType: "json",
         error: function(XMLHttpRequest, textStatus, errorThrown) {
                 //alert("Script was not successful");
          }, // error
         success: function(data){ refreshSelRegions(sid, image); }
       });
  });

  $(".abruzzo").on("click", function(e){
      e.preventDefault();
      ////alert('Abruzzo');
      $.ajax({
         type: "GET",
         url: "/cgi-bin/updateUserRegions.pl?region=1&sid="+sid, // URL of the Perl script
         contentType: "application/json; charset=utf-8",
         //dataType: "json",
         error: function(XMLHttpRequest, textStatus, errorThrown) {
                 //alert("Script was not successful");
          }, // error
         success: function(data){ refreshSelRegions(sid, image); }
       });
  });

  $(".molise").on("click", function(e){
      e.preventDefault();
      ////alert('Molise');
      $.ajax({
         type: "GET",
         url: "/cgi-bin/updateUserRegions.pl?region=11&sid="+sid, // URL of the Perl script
         contentType: "application/json; charset=utf-8",
         //dataType: "json",
         error: function(XMLHttpRequest, textStatus, errorThrown) {
                 //alert("Script was not successful");
          }, // error
         success: function(data){ refreshSelRegions(sid, image); }
       });
  });

  $(".campania").on("click", function(e){
      e.preventDefault();
      ////alert('Campania');
      $.ajax({
         type: "GET",
         url: "/cgi-bin/updateUserRegions.pl?region=4&sid="+sid, // URL of the Perl script
         contentType: "application/json; charset=utf-8",
         //dataType: "json",
         error: function(XMLHttpRequest, textStatus, errorThrown) {
                 //alert("Script was not successful");
          }, // error
         success: function(data){ refreshSelRegions(sid, image); }
       });
  });

  $(".puglia").on("click", function(e){
      e.preventDefault();
      ////alert('Puglia');
      $.ajax({
         type: "GET",
         url: "/cgi-bin/updateUserRegions.pl?region=13&sid="+sid, // URL of the Perl script
         contentType: "application/json; charset=utf-8",
         //dataType: "json",
         error: function(XMLHttpRequest, textStatus, errorThrown) {
                 //alert("Script was not successful");
          }, // error
         success: function(data){ refreshSelRegions(sid, image); }
       });
  });

  $(".basilicata").on("click", function(e){
      e.preventDefault();
      ////alert('Basilicata');
      $.ajax({
         type: "GET",
         url: "/cgi-bin/updateUserRegions.pl?region=2&sid="+sid, // URL of the Perl script
         contentType: "application/json; charset=utf-8",
         //dataType: "json",
         error: function(XMLHttpRequest, textStatus, errorThrown) {
                 //alert("Script was not successful");
          }, // error
         success: function(data){ refreshSelRegions(sid, image); }
       });
  });

  $(".calabria").on("click", function(e){
      e.preventDefault();
      ////alert('Calabria');
      $.ajax({
         type: "GET",
         url: "/cgi-bin/updateUserRegions.pl?region=3&sid="+sid, // URL of the Perl script
         contentType: "application/json; charset=utf-8",
         //dataType: "json",
         error: function(XMLHttpRequest, textStatus, errorThrown) {
                 //alert("Script was not successful");
          }, // error
         success: function(data){ refreshSelRegions(sid, image); }
       });
  });

  $(".sicilia").on("click", function(e){
      e.preventDefault();
      ////alert('Sicilia');
      $.ajax({
         type: "GET",
         url: "/cgi-bin/updateUserRegions.pl?region=15&sid="+sid, // URL of the Perl script
         contentType: "application/json; charset=utf-8",
         //dataType: "json",
         error: function(XMLHttpRequest, textStatus, errorThrown) {
                 //alert("Script was not successful");
          }, // error
         success: function(data){ refreshSelRegions(sid, image); }
       });
  });

  $(".sardegna").on("click", function(e){
      e.preventDefault();
      ////alert('Sardegna');
      $.ajax({
         type: "GET",
         url: "/cgi-bin/updateUserRegions.pl?region=14&sid="+sid, // URL of the Perl script
         contentType: "application/json; charset=utf-8",
         //dataType: "json",
         error: function(XMLHttpRequest, textStatus, errorThrown) {
                 //alert("Script was not successful");
          }, // error
         success: function(data){ refreshSelRegions(sid, image); }
       });
     });

});
