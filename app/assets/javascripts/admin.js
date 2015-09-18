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

	var userTypes = [];
    
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
    
    function getTitleForPersonType(type){
		if (userTypes.length == 0){
			var fetchedJSON = $.get("/assets/user_types.json", function(data){
					var parsedJSON = JSON.parse(data);
					var types_names = Object.keys(parsedJSON["user_types"]);
					for (var i = 0; i < types_names.length; i++){
						userTypes.append(parsedJSON[types_names[i]]["user_type_number"],types_names[i]);
					}
			});
		}
		
		for (var i = 0; i < usertypes.length; i++){
			if (userTypes[i][0] == type){
				return userTypes[i][1];
			  }
		}
		return "Unknown";
	}
    
    
    $(document).ready(function(){
     
     	
        
        $("#roster_file").change(function(){
            console.log("changed");
            if (this.files && this.files[0] && this.value.substr(-4) == ".xls"){
                loadExcel(this.files[0]);
                
            } 
            if (!(this.value.substr(-4) == ".xls")){
                alert('Please insert a valid ".xls" file (i.e. the downloaded "Organization Roster - Excel" IMOS report).');
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
        console.log("TODO: you need to update it to parse the input whether you include or exclude separate name and fields, or whether there are senior couples, or not");
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
        			e2.insertBefore('<tr class="to-add"><td>'+e+'</td><td>'+getTitleForPersonType(positions[i])+'</td></tr>');
        			inserted = true;
        			return false;		
        		}
        	});
        	
        	if (!inserted){
        		$("#current_users tbody").append('<tr class="to-add"><td>'+e+'</td><td>'+getTitleForPersonType(positions[i])+'</td></tr>');
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
		
		$(".category-selector").each(function(){
			
			$(this).val($(this).attr("default-category"));
		})
		
		$.each(languages, function(i,e){
			$(".language-selector").append("<option>"+e+"</option>");	
			
		});
		
		$.each(languages, function(i,e){
			$("."+e).val(e);	
		});
		/*
		$.each(ids, function(i,e){
			
			validLangs = validLangsForId(e);
			
			$.each(validLangs, function(i,e){
				$()	
			});
			
			$(".new-lang-picker").append("<li><a href='#' class='new-lang-option'>"+e+"</a></li>");
		});
		*/
		$(".locals-group").each(function(i,e){
			currentLangs = [];
			notCurrentLangs = [];
			
			$(this).find(".language-field").each(function(i2,e2){
				currentLangs.push($(e2).text().trim());
				console.log(currentLangs);
			});
			
			
			
			$.each(languages, function(i2,e2){
				if (currentLangs.indexOf(e2) < 0){
					notCurrentLangs.push(e2);
					$(e).find(".new-lang-picker").append("<li><a href='#' class='new-lang-option'>"+e2+"</a></li>");
				}
			});
			
			$(e).find(".new-lang-picker").append("<li><a href='#' class='new-lang-option'>Other Language</a></li>");
			//$(e).find(".new-language-field").hide();
			
		});
		
		
		// When clicking the addItemRow button, you should get a blank row for a new item.
		
		$("#addItemRow").click(function(){
			/*
			* New accordion method is too complex for this. 
			
			// Get new element (grab the first for semplicity)
			newRow = $(".item-row:first").clone(true, true);
			$(newRow).attr("item_id","-1"); // Will be a new item.
			$(newRow).find(".category-selector").val("Book"); // Default value.
			$(newRow).find(".name-field").val("New Item");
			$(newRow).find(".unit-size-field").val(1);
			$(newRow).find(".language-selector").val("Italian");
			$(newRow).find(".quantity-field").val(10);
			$(newRow).find(".limit-field").val(0);
			*/
			
			nextIndex = (parseInt($(".local-group").last().attr("id").match(/\d+/))+1).toString();
			
			newItem = "<div class='panel panel-default'>\
					<div class='item-row panel-heading' data-toggle='collapse' data-parent='#item-accordion' href='#collapse"+nextIndex+"'>\
						<div class='row'>\
							<input name='id' type='hidden' class='item-field item-id-field' value='"+nextIndex+"' />\
							<span class='col-xs-4'>\
							<span class='btn-group item-save-delete'>\
								<button class='no-collapse btn btn-xs btn-success save-item-btn'><span class='glyphicon glyphicon-ok'></span></button>\
								<button class='no-collapse btn btn-xs btn-danger delete-item-btn'><span class='glyphicon glyphicon-remove'></span></button>\
							</span>\
								<select name='category' class='no-collapse item-field category-selector Book'>\
									<!-- will fill in automatically with jQuery -->\
								</select>\
							</span>\
							<span class='col-xs-4'>\
								<input name='item-name' type='text' class='no-collapse item-field item-name-field' value='New Item'/>\
							</span>\
							<span class='col-xs-4'>\
								<input name='unit-size' type='number' class='no-collapse item-field unit-size-field' value='1'/>\
							</span>\
						</div>\
					</div>\
					<div class='local-group panel-collapse collapse in' id='collapse"+nextIndex+"'>\
						<div class='panel-body locals-group'>\
							<div class='local-header row'>\
								<h3 class='col-xs-4'>Language</h3>\
								<h3 class='col-xs-4'>In Stock</h3>\
								<h3 class='col-xs-4'>Order Limit</h3>\
							</div>\
						<div class='row'>\
								<span class='col-xs-12 text-center new-lang-area'>\
									<div class='btn-group'>\
										<button type='button' class='btn btn-primary dopdown-toggle' data-toggle='dropdown'>\
											<span class='caret'></span>\
											<span class='sr-only'>Toggle Dropdown</span>\
										</button>\
										<ul class='new-lang-picker dropdown-menu' role='menu'>\
											<!-- will fill in automatically with jQuery -->\
										</ul>\
										<button type='button' class='addLanguageRow btn btn-primary'>Add</button>\
										<input type='text' class='btn btn-small new-language-field' value='Other Language' />\
									</div>\
								</span>\
							</div>\
						</div>\
					</div>\
			</div>"
			
			
		
			
			$(newItem).appendTo("#item-accordion");
		
			$.each(categories, function(i,e){
				$(".panel-default").last().find(".category-selector").append("<option>"+e+"</option>");	
				
			});
			
			

		});
		
		$("#item-accordion").on("click",".no-collapse",function(e){
			console.log(e);
			e.stopPropagation();
		})
		
		$("#item-accordion").on("click",".save-item-btn",function(){
			// Gather info and save this item to the server.
			itemPanel = $(this).closest(".panel");
			
			id = $(itemPanel).find(".item-id-field").val().toString();
			console.log(id);
			
			category = $(itemPanel).find(".category-selector").val();
			item_name = $(itemPanel).find(".item-name-field").val();
			unit_size = $(itemPanel).find(".unit-size-field").val();
			
			languages = [];
			quantities = [];
			limits = [];
			
			$(itemPanel).find(".language-field").each(function(i,l){languages.push($(l).text().trim())});
			$(itemPanel).find(".quantity-field").each(function(i,q){quantities.push($(q).val())});
			$(itemPanel).find(".limit-field").each(function(i,l){limits.push($(l).val())});
			
			console.log(languages);
			
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
					console.log("We got done");
				},
				beforeSend: function(xhr) {
					xhr.setRequestHeader('X-CSRF-Token',$('meta[name="csrf-token"]').attr('content'));
					console.log(xhr);
				}
			});
			
		});
		
		$("#item-accordion").on("click", ".addLanguageRow", function(){
			console.log("hello?");
			// Validate current box's content. NOT "Other Language"
			newLang = $(this).parent().children(".new-language-field").val();
			if (newLang.toLowerCase() == "Other Language".toLowerCase()){
				// don't do anything, we need a better language.
				alert("TODO: Get a better modal box for this thing... we don't want to use alert. \n Anyway, you need to actually specify a new language");
			} else {
				// Add a new row
				$("\
				<div class='row'>\
					<span class='col-xs-4'>\
						<button class='btn btn-xs btn-danger modify-local-btn remove-local-btn'>\
							Delete\
						</button>\
						<p class='item-field language-field "+newLang+"'>"+newLang+"</p>\
					</span>\
					<span class='col-xs-4'>\
						<input type='number' class='item-field quantity-field' value='0'>\
					</span>\
					<span class='col-xs-4'>\
						<input type='number' class='item-field limit-field' value='0'>\
					</span>\
				</div>").insertBefore($(this).closest(".row"));
				
			}
		});
		
		
		$("#item-accordion").on("click", ".new-lang-option",function(){
			
			if ($(this).text() == "Other Language"){
				$(this).closest(".new-lang-area").find(".new-language-field").val($(this).text()).show().focus();
				$(this).closest(".new-lang-area").find(".addLanguageRow").text("Add");
			} else {
				$(this).closest(".new-lang-area").find(".new-language-field").val($(this).text()).hide();
				$(this).closest(".new-lang-area").find(".addLanguageRow").text("Add "+$(this).text());
			}
		});
		
		
		$(".item-row").on("click",".save-item-button", function(){
														   // Gather information
			 category = $(this).parent().parent().find(".category-selector").val();
			 item_name = $(this).parent().parent().find(".name-field").val();
			 unit_size = $(this).parent().parent().find(".unit-size-field").val();
			 
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
		$(".save-item-button").click(function(){unit-size-fieldunit_size-field").val();
			
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