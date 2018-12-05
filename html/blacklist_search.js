function uniqueArray(array) {
    return $.grep(array, function(el, index) {
        return index == $.inArray(el, array);
    });
};


function createResultTable( results, search_block )
{
   //$('div#blacklistResults').text("Blacklist, risultati ricerca");
   myTable = document.createElement('TABLE');
   myTable.setAttribute("border", 1);
   // node tree
   // alert(results);
   var data = results.split("|");
   data = uniqueArray( data );
   var oneRecord;

   if( results )
   {
	   for (i = 0; i < data.length; i++) {
		    oneRecord = data[i];
		    tr = myTable.insertRow(myTable.rows.length);
		    td = tr.insertCell(tr.cells.length);
		    td.innerHTML = oneRecord;
		    td = tr.insertCell(tr.cells.length);
		    var btn = document.createElement("BUTTON");        // Create a <button> element
		    var t = document.createTextNode("Blocca");       // Create a text node
		    btn.name = "block_btn" + i;
		    btn.id = "block_btn" + i;
		    btn.value = oneRecord;
		    btn['number'] = i;
		    btn.onclick=function blockUserFromCompanyName( )
		    {
		      var  CompanyName = this.value;
		      var  TableIndex = this.number;
		      var  td_clicked = $(this).parent();
		      // get also the sid
		      var sid = $("#sid").val();
		      var args = "?CompanyName=" + CompanyName + "&sid=" + sid + "&TableIndex=" + TableIndex;
		      //alert( CompanyName );
		      $.ajax({
		         type: 'POST',
		         url: '/cgi-bin/blockCompany.pl'+ args,
		         data: { 'CompanyName' : CompanyName, 'sid' : sid, 'TableIndex' : TableIndex },
		         success: function(res) {
				// alert('Blocking Company: ' + CompanyName + ' TableIndex: ' + TableIndex );
				//
				// retrieve the table

		                $(td_clicked).empty();
		                //tbl.rows[TableIndex].style.display = 'none';

		        return false;
		        },
		        error: function(XMLHttpRequest, textStatus, errorThrown) {
		               // alert("Script was not successful: " + XMLHttpRequest + " " + textStatus + " " + errorThrown );
		               }
		      });
		    };
		    btn.appendChild(t);

		    if( search_block == null )
		    {
		        td.appendChild(btn);
		    }


	    }
    }
    var my_div = document.getElementById('blacklistResults');
    my_div.innerHTML = "";
    my_div.appendChild(myTable);

};

$(document).ready(function(){
   $("form#BlackListForm").submit(function() {
   var key_value = $("#key_value").val(); // get search string
   var args = "?key_value=" + key_value;

   // alert( "debug = " + "/cgi-bin/blacklist_search.pl" + args );

   $.ajax({
      type: 'POST',
      url: '/cgi-bin/blacklist_search.pl' + args, // URL of the Perl script
      //contentType: 'application/json; charset=utf-8',
      //dataType: "json",
      data: { 'key_value': key_value },
      error: function(XMLHttpRequest, textStatus, errorThrown) {
              //alert("Script was not successful: " + XMLHttpRequest + " " + textStatus + " " + errorThrown );
	     }, // error
      success: function(data){
		//alert("Executing blacklist search: " + data.results);
                createResultTable( data.results, data.search_block );
                return false;
             }  // success
   }); // ajax

   return false;
   }); // form function
}); // document
