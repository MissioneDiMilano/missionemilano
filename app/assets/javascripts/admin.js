//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/


// Check we are on the right page and go!
if (window.location.pathname == "/admin/users"){
    
    var workbook = null;
    var names = [];
    var accounts = [];
    var release_dates = [];

    
    function loadExcel(input){
        console.log("parseexcel");
        var reader = new FileReader();
        
        reader.onload = function(e){
            workbook = XLS.read(e.target.result, {type: "binary"});
            console.log("loaded workbook");
            
            
            parseExcel();
            createPreviewTable();
        }
        
        reader.readAsBinaryString(input);
        
        
    }
    
    
    
    
    $(document).ready(function(){
        
        $("#roster_file").change(function(){
            console.log("changed");
            if (this.files && this.files[0] && this.value.substr(-4) == ".xls"){
                loadExcel(this.files[0]);
                
            } 
            if (!(this.value.substr(-4) == ".xls")){
                alert("Please insert a valid '.xls' file (that's the default downloaded one).");
            }
    })
    
    })
    
    
    function createRef(letter,number){
        return letter+number.toString();
    }
    
    function parseExcel(){
    	
    	// Reset variables in case of second load.
    	names = [];
    	accounts = [];
    	release_dates = [];
    	
        console.log("parsing Excel");
        sheet = workbook.Sheets.Sheet1;
        var begin_data = 1;
        var end_data = null;
        // Find "name" column.
        var name_title = "Missionary Name"; // TODO: user input this.
        var findNameInColumn = "A"
        // TODO: Create better searching, we need to actually search for the oclumn.
        
        var current_value = null;
        var counter = 1;
        
        
        // Loop through column A looking for the name_title
        // That way we can know when the data starts.
        while (current_value !== name_title && counter < 50){
            console.log(counter.toString()+": "+current_value);
            current_value = sheet[createRef(findNameInColumn,counter)].v;
            begin_data = ++counter;
            
        }
        
        // TODO: Detect no find.
        
        // Loop through column A to find where it ends.
        counter = 1;
        while (sheet[createRef(findNameInColumn, counter)] !== undefined){
            // this cell is defined, keep going.
            counter++;
        }
        // reference was undefined, stop, data end.
        end_data = counter;
        
        
        // Now that we know when our data begins, ends, and where, parse it.
        
        for (var i = begin_data; i < end_data; i++){
            names.push(sheet[createRef("A", i)].v);
            accounts.push(sheet[createRef("H",i)].v);
            release_dates.push(sheet[createRef("J",i)].v);
        }
        // We have created the necessary fields to draw the table.
    }
    
    function createPreviewTable(){
        // For each name...
        table_index = 0;
        var temp_names = names;
        
        $("#current_users tbody tr").each(function(i,e){
            
            if ( temp_names.find(e.text()) > 0){
            	// If it's not in the list, it's to delete.
            	e.addClass("to-delete");
            } else {
            	// Take it out of temp_names - so we know which didn't exist before.
            	temp_names.pop(e.text());
            }
        });
        
        $.each(temp_names, function(i,e){
        	console.log(i);
        	var inserted = false;
        	// Alphabetically insert.
        	$("#current_users tbody tr").each(function(i2,e2){
        		console.log(e2);
        		if (e > e2.childNodes[0].InnerText){
        			e2.insertBefore('<tr class="to-add"><td>'+e+'</td><td>'+release_dates[i]+'</td></tr>');
        			inserted = true;
        			return false;		
        		}
        	});
        	
        	if (!inserted){
        		$("#current_users tbody").append('<tr class="to-add"><td>'+e+'</td><td>'+release_dates[i]+'</td></tr>');
        	}
        	
        });
        
        
    }
}