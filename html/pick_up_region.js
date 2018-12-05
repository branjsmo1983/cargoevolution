
$(document).ready(function () {

$("#pick_up_region").change(function(event) {
  // Get some values from elements on the page: 
    var pick_up_region = $('#pick_up_region option:selected').attr('value'); // get data
    var form_type = $('#form_type2').val();
    //alert( form_type );
    perlExecutePickUp(pick_up_region, form_type);
 });
});

function perlExecutePickUp(pick_up_region, form_type){
    $.ajax({
        type: 'POST',
        url: '/cgi-bin/pick_up_region.pl?pick_up_region='+pick_up_region+"&form_type="+form_type,
        data: { 'pick_up_region': pick_up_region, 'form_type' : form_type },
        success: function(res) {
        $('#pickUpRegionDiv').empty();
        //alert( res);
        document.getElementById("pickUpRegionDiv").innerHTML=res;
        //document.write(res);
        },
        error: function() {alert("did not work");}
    });
};

