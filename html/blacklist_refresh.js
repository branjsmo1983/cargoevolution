var ref_interval_timer_blacklist=0;

function uniqueArray(array) {
    return $.grep(array, function(el, index) {
        return index == $.inArray(el, array);
    });
};

function refreshBlacklistTable()
{
   // alert('Refreshing table');
   var sid = $("#sid").val();
   var args = "?sid=" + sid;

   $.ajax({
         type: 'POST',
         url: '/cgi-bin/getBlacklist.pl'+ args,
         data: { 'sid' : sid },
         success: function(res) {
                   // alert("Refreshing blacklist: " + res.success);
		   createBlacklistTable( res.success, res.search_block );
                   return false;
                },
         error: function(XMLHttpRequest, textStatus, errorThrown) {
                       //alert("Script was not successful: " + XMLHttpRequest + " " + textStatus + " " + errorThrown);
                }
          });
};

function createBlacklistTable( results, search_block )
{
   //$('div#blacklistResults').text("Blacklist, risultati ricerca");
   myTable = document.createElement('TABLE');
   myTable.setAttribute("border", 1);
   // node tree
   var data = results.split("|");
   data = uniqueArray( data );
   var oneRecord;
   //alert( "data.length: " + data.length );
   if( results )
   {
	   for (i = 0; i < data.length; i++) {
		    oneRecord = data[i];
		    tr = myTable.insertRow(myTable.rows.length);
		    td = tr.insertCell(tr.cells.length);
		    td.innerHTML = oneRecord;
		    td = tr.insertCell(tr.cells.length);
		    var btn = document.createElement("BUTTON");        // Create a <button> element
		    var t = document.createTextNode("Sblocca");       // Create a text node
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
		         url: '/cgi-bin/allowCompany.pl'+ args,
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
    var my_div = document.getElementById('blacklistUser');
    my_div.innerHTML = "";
    my_div.innerHTML = "<h2>Blacklist:</h2>";
    //var blacklist_text = document.createTextNode("Blacklist:");
    //my_div.appendChild(blacklist_text);
    my_div.appendChild(myTable);

};

$(document).ready(function(){

   var sid = $("#sid").val();
   var args = "?sid=" + sid;
   ref_interval_timer_blacklist = setInterval ( function() { refreshBlacklistTable(); }, 3000 );

   $.ajax({
         type: 'POST',
         url: '/cgi-bin/getBlacklist.pl'+ args,
         data: { 'sid' : sid },
         success: function(res) {
                   //alert("Refreshing blacklist: " + res.success);
		   createBlacklistTable( res.success, res.search_block );
                   return false;
                },
         error: function(XMLHttpRequest, textStatus, errorThrown) {
                       //alert("Script was not successful: " + XMLHttpRequest + " " + textStatus + " " + errorThrown);
                }
          });

}); // document
