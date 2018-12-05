function getParameterByName(name, url) {
    if (!url) {
      url = window.location.href;
    }
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
};


$(document).ready(function () {

$("#regions").click(function(event) {
	event = event || window.event;
        event.target = event.target || event.srcElement;
        event.preventDefault = event.preventDefault || function() {
            this.returnValue = false;
        };

        var url = event.target.href;

        if (!url) {
            return true;
        }

        event.preventDefault();

        console.log("Make Ajax request to " + url);
        // Get some values from elements on the page: 
        //var delivery_region = 14; // set data
	var username = getParameterByName("username", url);
	var delivery_region = getParameterByName("id", url);
        //alert(delivery_region);
        perlExecuteMapDelivery( delivery_region );
        perlExecuteMapDeliveryRegenarateSelector( delivery_region );
 });
});

function perlExecuteMapDelivery(delivery_region){
    
    $.ajax({
        type: 'POST',
        url: '/cgi-bin/delivery_region.pl?delivery_region='+delivery_region,
        data: { 'delivery_region': delivery_region },
        success: function(res) {
        document.getElementById("deliveryRegionDiv").innerHTML=res;
        //document.write(res);
        },
        error: function() {alert("did not work");}
    });
};

function perlExecuteMapDeliveryRegenarateSelector(delivery_region){
    
    $.ajax({
        type: 'POST',
        url: '/cgi-bin/fun_wrp_generateHTMLSelectorRegionIT.pl?delivery_region='+delivery_region,
        data: { 'delivery_region': delivery_region },
        success: function(res) {
        $('#delivery_region').empty();
	document.getElementById("delivery_region").innerHTML = res;
        // document.getElementById("deliveryRegionDiv").innerHTML=res;
        },
        error: function() {alert("did not work");}
    });
};

