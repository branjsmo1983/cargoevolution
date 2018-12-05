
$(document).ready(function () {

$("#delivery_region").change(function(event) {
  // Get some values from elements on the page: 
    var delivery_region = $('#delivery_region option:selected').attr('value'); // get data
    //alert(delivery_region);
    var form_type = $('#form_type2').val();
    perlExecuteDelivery(delivery_region, form_type);
 });
});

function perlExecuteDelivery(delivery_region, form_type){
    $.ajax({
        type: 'POST',
        url: '/cgi-bin/delivery_region.pl?delivery_region='+delivery_region+"&form_type="+form_type,
        data: { 'delivery_region': delivery_region, 'form_type' : form_type },
        success: function(res) {
        $('#deliveryRegionDiv').empty();
        document.getElementById("deliveryRegionDiv").innerHTML=res;
        //document.write(res);
        },
        error: function() {alert("did not work");}
    });
};

