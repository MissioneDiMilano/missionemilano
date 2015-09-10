//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/


// Check we are on the right page and go!
if (window.location.pathname == "/admin/users"){
    
    var workbook = null;
    var names = [];
    var user_names = [];
    var positions = [];
    var areas = [];
    var zones = [];

    
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
    	});
    	
    	$("#submit_users").click(function(){
    		// Fill in the hidden tags.
    		$("#names").val(names.join("|"));
    		$("#user_names").val(user_names.join("|"));
    		$("#types").val(positions.join("|"));
    		$("#areas").val(areas.join("|"));
    		$("#zones").val(areas.join("|"));
    		alert(names.length);
    	});
    
    });
    
    
    function createRef(letter,number){
        return letter+number.toString();
    }
    
    function parseExcel(){
    	
    	// Reset variables in case of second load.
    	names = [];
    	user_names = [];
    	positions = [];
    	areas = [];
    	zones = [];
    	
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
            user_names.push(sheet[createRef("H",i)].v);
            positions.push(sheet[createRef("L",i)].v.replace(/\d/,""));
            areas.push(sheet[createRef("T",i)].v);
            zones.push(sheet[createRef("R",i)].v);
        }
        // We have created the necessary fields to draw the table.
    }
    
    function createPreviewTable(){
        // For each name...
        table_index = 0;
        var temp_names = names.clone();
        
        $("#current_users tbody tr").each(function(i,e){
            location_ind = temp_names.indexOf(e.children[0].innerText)
            if ( location_ind < 0){
            	// If it's not in the list, it's to delete.
            	//console.log(e.childNodes[0].text);
            	$(e).addClass("to-delete");
            } else {
            	// Take it out of temp_names - so we know which didn't exist before.
            	temp_names.splice(location_ind,1);
            }
        });
        
        $.each(temp_names, function(i,e){
        	//console.log(i);
        	var inserted = false;
        	// Alphabetically insert.
        	$("#current_users tbody tr").each(function(i2,e2){
        		//console.log(e2);
        		if (e > e2.children[0].InnerText){
        			e2.insertBefore('<tr class="to-add"><td>'+e+'</td><td>'+positions[i]+'</td></tr>');
        			inserted = true;
        			return false;		
        		}
        	});
        	
        	if (!inserted){
        		$("#current_users tbody").append('<tr class="to-add"><td>'+e+'</td><td>'+positions[i]+'</td></tr>');
        	}
        	
        });
        
        
    }
    
    Array.prototype.clone = function() {
		return this.slice(0);
	};
    
}

if (window.location.pathname == "/admin/orders/inventory" || window.location.pathname == "/admin/orders/inventory"){
	
	$(document).ready(function(){
	
		console.log($('meta[name="csrf-token"]').attr("content"));
		$.ajaxSetup({
			//
		});
	
		// Create HTML for the categoryand language pickers.
		$.each(categories, function(i,e){
			$(".category-selector").append("<option>"+e+"</option>");	
			
		});
		
		$.each(languages, function(i,e){
			$(".language-selector").append("<option>"+e+"</option>");	
			
		});
		
		$.each(languages, function(i,e){
			$("."+e).val(e);	
		});
		
		// When clicking the addItemRow button, you should get a blank row for a new item.
		
		$("#addItemRow").click(function(){
			
			// Get new element (grab the first for semplicity)
			newRow = $(".item-row:first").clone(true, true);
			$(newRow).attr("item_id","-1"); // Will be a new item.
			$(newRow).find(".category-selector").val("Book"); // Default value.
			$(newRow).find(".name-field").val("New Item");
			$(newRow).find(".unit_size-field").val(1);
			$(newRow).find(".language-selector").val("Italian");
			$(newRow).find(".quantity-field").val(10);
			$(newRow).find(".limit-field").val(0);
			
			$(newRow).appendTo(".items-table-body");
			
			console.log("TODO: this is a problem in that it only works if there are already Items in the db.\
				Hopefully we'll always have items - but if not, we'll get an error, and won't be \
				able to add any more. Thus, we need to make a default case.");
		});
		
		$(".item-row").on("click",".save-item-button", function(){
														   // Gather information
			 category = $(this).parent().parent().find(".category-selector").val();
			 item_name = $(this).parent().parent().find(".name-field").val();
			 unit_size = $(this).parent().parent().find(".unit_size-field").val();
			 
			 languages = [];
			 quantities = [];
			 limits = [];
			 
			 id = $(this).closest(".item-row").addClass("edited-item").attr("item_id");
			 
			 $(".item-row[item_id*='"+id+"']").each(function(i,e){
				   languages.push($(e).find(".language-selector").val());
				   quantities.push($(e).find(".quantity-field").val());
				   limits.push($(e).find(".limit-field").val());
				   
				   
			 });
			 console.log(category, item_name, unit_size, languages, quantities, limits);
			 console.log("TODO: create ajax request");
			 
			 $.ajax({
			 	type: "POST",
			 	url: "/admin/orders/inventory/ajax", 
			 	
			 	data: {
			 		op: "Add/Edit item",
			 		id: id,
			 		category: category,
			 		name: item_name,
			 		unit_size: unit_size,
			 		'languages[]': languages,
			 		'quantities[]': quantities,
			 		'limits[]': limits
			 		},
			 	done: function(data){
			 		console.log(data);
			 	},
			 	beforeSend: function(xhr) {
					 xhr.setRequestHeader('X-CSRF-Token',$('meta[name="csrf-token"]').attr('content'));
					 console.log(xhr);
				 }
			 });
			 
		});
		
		/*
		$(".save-item-button").click(function(){
			// Gather information
			category = $(this).parent().parent().find(".category-selector").val();
			item_name = $(this).parent().parent().find(".name-field").val();
			unit_size = $(this).parent().parent().find(".unit_size-field").val();
			
			languages = [];
			quantities = [];
			limits = [];
			
			id = $(this).closest(".item-row").addClass("edited-item").attr("item_id");
			
			$(".item-row[item_id*='"+id+"']").each(function(e,i){
				languages.push($(e).children(".language-selector").val());
				quantities.push($(e).children(".quantity-field").val());
				limits.push($(e).children(".limit-field").val());
				
				
			});
			console.log(category, item_name, unit_size, languages, quantities, limits);
			
		
		});
		*/
		// When a row is edited, we need to mark that row as to save 
		// TODO update related information
		$(".item-table-body").on("change",".item-field", function(){
			// Find parent item-row's attr item_id
			id = $(this).closest(".item-row").addClass("edited-item").attr("item_id");
			$(this).parent().siblings().last().append('<button class="save-item-button"><span class="glyphicon glyphicon-floppy-open"></span> Save</button>');
			// Find all rows with this id, add the edited_item class
			$(".item-row[item_id*='"+id+"']").addClass("affected-item");
			
		})
		
		
		
		
		
		
		
	
	});
	
	
	
}