//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/

//var workbook = XLS.read((new FileReader()).readAsBinaryString($("#roster_file")[0].files[0]), {type: "binary"});

// Check we are on the right page and go!
if (window.location.pathname == "/missionary/orders/new"){
	

	$(document).ready(function(){
		
		/*
		*	 Define the objects:
		*
		*/
		
		inventory = {};
		
		// An object ot represent an order...
		// Will be used either to represent the cumulitave "on orders" or the current order...
		order = {
			
			// Will hold all of the orderItems representing items. 
			items: [], 
			
			// 
			getCountItemLanguage: function(){
				
				
			},
			
			// Add an item to the count
			
		}
		
		// Represents a unique item with its languages. There will not be duplicate item records.
		orderItem = {
			id: null,
			name: null,
			unit_size: null,
			category: null,
			languages: [],
			quantities: [],
			limits: []
		}
	
		shoppingCart = {
			
			orderBuilder: Object.create(order),
			currentOrders: Object.create(order)
			
		}	
		
		/* 
		* End object definitions
		*/
		
		// Parse the items passed to the inventory variable...
		setUpInventory();
		
		// parse the items apssed to the onOrds variable...
		setUpOnOrder();
		
		// Set the shopping-cart-viewer for the first time...
		
		// Seed order
		testOrder = Object.create(orderItem);
		testOrder.id = 1;
		testOrder.name= "Book of Mormon";
		testOrder.languages = ["English","German"];
		testOrder.quantities = [10,20];
		shoppingCart.orderBuilder.items.push(testOrder);
		
		updateShoppingCartViewer();
		
	/*	$(".shopping-cart").BootSideMenu({
			side: "right",
			autoClose: true
		})
		*/
		
		closedPosition = $(".shopping-cart")[0].offsetWidth - 15;
		
		Draggable.create($(".shopping-cart")[0], {
				   type:"x",
				   throwProps:true, //enables the momentum-based flicking (requires ThrowPropsPlugin)
				   edgeResistance: 0.9, //you can set this to 1 if you don't want the user to be able to drag past the snap point. This controls how much resistance there is after it hits the max/min.
				   maxDuration:0.3, //don't let the animation duration exceed 0.3 second (you can tweak this too of course)
				   bounds: {maxX:closedPosition, minX:0}, 
				   onClick: function() { //when the user clicks/taps on the menu without dragging, we'll toggle it...
					 if (this.target._gsTransform.x === closedPosition) { 
					   TweenLite.to(this.target, 0.3, {x:0});
					 } else {
					   TweenLite.to(this.target, 0.3, {x:closedPosition});
					 }
				   },
				   snap: {
					 x: [0, closedPosition]
				   }
				 });
		$(".shopping-cart").first().click();
		
		// When you click a category...
		$(".category-well").on("click", ".category-selector",function(){
			
		
			
			// Hide all shown items....
			$(".item-selector").hide();
			
			// Show the ones with my title as the category.
			tagValue = $(this).attr("cat-attr")+"Item";
			$(".item-selector[cat-attr*='"+tagValue+"'").show();
			 
		
		});
		
		$(".item-well").on("click", ".item-selector", function(){
			
			fillViewerWell($(this).find(".caption").text());
			
		});
		
		$(".item-viewer").on("click", ".iv-order-add", function(){
			
			// Update the cart:
			var newOrder = Object.create(orderItem);
			newOrder.name = $(".item-name-view").text();
			$(".iv-language-view").each(function(i,e){
				newOrder.languages.push($(e).text());
			});
			$(".iv-quantity-view").each(function(i,e){
				newOrder.quantities.push($(e).text());
			})
			
			addToShoppingCartBuilder(newOrder);
			updateShoppingCartViewer();
			newOrder = null;
		});
		
		clearViewerWell();
		

		
		
		
		
		
		
		
		
		
	});
	
	
	/* 
	*
	*  Declare functions
	*
	*/
	
	function clearViewerWell(){
		$(".item-viewer").find(".iv-clearable").text("");
		$(".item-viewer").find(".item-locals-header").hide();
	}
	
	
	function fillViewerWell(itemName){
		
		clearViewerWell();
		$(".item-viewer").find(".item-locals-header").show();
		var foundItem;
		for (i = 0; i < items.length; i++){
				if (items[i].name == itemName){
					foundItem = items[i];
				}
		}
		
		$(".item-name-view").text(foundItem.name);
		$(".item-category-view").text(foundItem.category);
		$(".item-unit-size-view").text(foundItem.unit_size);
		
		
		for (j = 0; j < foundItem.languages.length; j++){
			
			element = "\
				<span class='row item-local-option'>\
					<span class='col-xs-3'>\
						<p class='iv-language-view'>"+foundItem.languages[j]+"</p>\
					</span>\
					<span class='col-xs-3'>\
						<input class='iv-quantity-view' type='number' value='"+ getQuantityForItem(foundItem.name, foundItem.languages[j]) +"'/>\
					</span>\
					<span class='col-xs-3'>\
						<p class='iv-total-viewer'></p>\
					</span>\
				</span>\
			"
			console.log(element);
			
			
			$(".item-locals-view").append(element);
		}
		
		
		
	}
	
	
	
	function setUpInventory(){
		for (i = 0; i<items.length; i++){
			inventory[items[i].id.toString()] = items[i];
		}	
	}
	
	function setUpOnOrder(){
		
		onOrderB = {};
		
		for (i = 0; i<oldOrders.length; i++){
			itemId = oldOrders[i].item.toString();
			itemLanguage = oldOrders[i].language.toString();
			unfilledQuantity = oldOrders[i].quantity - oldOrders[i].fulfilled;
			
			if (unfilledQuantity > 0){ //Only do anything if we've still got to fill the order.
				if (onOrderB.hasOwnProperty(itemId)){
					// Then we already wanted something of this item...
					languageIndex = onOrderB[itemId].languages.indexOf(itemLanguage);
					if (languageIndex < 0){
						// Then we haven't ordered this language yet.
						// Add it.
						onOrderB[itemId].languages.push(itemLanguage);
						onOrderB[itemId].quantities.push(unfilledQuantity);
						
					} else {
						// We've already requested this language. Add it.
						onOrderB[itemId].quantities[languageIndex] += unfilledQuantity;
					}
				} else { 
					// We haven't wanted this yet, create it.
					onOrderB[itemId] = Object.create(orderItem);
					onOrderB[itemId].languages = [itemLanguage];
					onOrderB[itemId].quantities = [unfilledQuantity];
				}
			}
			
		}
		
		shoppingCart.currentOrders = onOrderB;
	}
	
	function updateShoppingCartViewer(){
		$(".shopping-cart-list").html("");
		// loop through the items...
		var newItems = shoppingCart.orderBuilder.items;
		//var newItemsKeys = Object.keys(shoppingCart.orderBuilder);
		for (var i = 0; i<newItems.length; i++){
			// For each item, create an element with each language.
			var itemEntry = $("<div/>").addClass("item-entry");
			$(itemEntry).append("<h4>"+newItems[i].name+"</h4");
			var localsList = $("<ul/>").addClass("item-entry-languages");
			
			var itemsLanguages = newItems[i].languages;
			//var itemsLanguagesKeys = Object.keys(itemsLanguages);
			for (var j = 0; j<itemsLanguages.length; j++){
				localsList.append("<li>"+itemsLanguages[j]+"</li>");
			}
			$(itemEntry).append(localsList)
			$(".shopping-cart-list").append(itemEntry);
		}
	}
	
	function addToShoppingCartBuilder(newOrderItem){
		var added = false;
		for (var i = 0; i < shoppingCart.orderBuilder.items.length; i++){
			if (shoppingCart.orderBuilder.items[i].name == newOrderItem.name){
				// It's the same thing, add it on.
				// For each language
				for (var j = 0; j < newOrderItem.languages.length; j++){
					var langIndex = shoppingCart.orderBuilder.items[i].languages.indexOf(newOrderItem.languages[j]);
					console.log(shoppingCart.orderBuilder.items[i]+" - "+newOrderItem.languages[j]);
					if (langIndex<0){
						// Doesn't contain this language, add it in.
						shoppingCart.orderBuilder.items[i].languages.push(newOrderItem.languages[j]);
						shoppingCart.orderBuilder.items[i].quantities.push(newOrderItem.quantities[j]);
						added = true;
					} else {
						// it contains it. Replace with our new one.
						shoppingCart.orderBuilder.items[i].quantities[langIndex] = newOrderItem.quantities[j];
						added = true;
						
					}
				}
			}
		}
		if (!added){
			shoppingCart.orderBuilder.items.push(newOrderItem);
		}
	
	}
	
	function getQuantityForItem(name, lang){
	    var langIndex = null;
	    for (var i = 0; i < shoppingCart.orderBuilder.items.length; i++){
	        if (shoppingCart.orderBuilder.items[i].name == name && (langIndex = shoppingCart.orderBuilder.items[i].languages.indexOf(lang)) > -1){
	            return shoppingCart.orderBuilder.items[i].quantities[langIndex];
	        }
	    }    
	
	}
	
	function submitOrder(){
	    // Build data string...
	    var dataJSON = {};
	    for (var i = 0; i < shoppingCart.orderBuilder.items.length; i++){
	        for (var j = 0; j < shoppingCart.orderBuilder.items[i].languages.length; j++){
	            dataJSON[shoppingCart.orderBuilder.items[i].name][shoppingCart.orderBuilder.items[i].languages[j]] = shoppingCart.orderBuilder[i].quantities[j];
	        }
	    }
	    
	    // Submit it.
	    $.ajax({
	        type: "POST",
            url: "/ajax/orders", 
            
            data: {
                "itemJSON": itemJSON
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
	}
	
	
	
}