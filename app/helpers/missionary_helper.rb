module MissionaryHelper
	
	def return_item_thumbnail(title, category, element_classes)
		
		element_classes = element_classes + [category+"Item", "item-selector"]
		return return_thumbnail(@urls[1], title, element_classes, category+"Item")
	end
	
	def return_category_thumbnail(title, element_classes)
		element_classes = element_classes + [title+"Cat", "category-selector"]
		return return_thumbnail(@urls[0], title, element_classes, title)
	end
	
	
	def return_thumbnail(picture_url, title, element_classes, cat_attr="")
		classes = element_classes.join(" ")
		string_builder = ""
		string_builder = string_builder + '<div class="col-xs-4 col-md-2">'
		string_builder = string_builder + (('<div class="thumbnail select-component '+classes.to_s) + '"')
		unless cat_attr.eql?("")
			string_builder = string_builder + ((' cat-attr="'+ cat_attr)+'"')	
		end
		string_builder = string_builder	+'>'
		string_builder = string_builder + (('<img src="'+picture_url.to_s)+'">')
		string_builder = string_builder + (('<div class="caption"><h5>'+title.to_s)+'</h5></div>')
		string_builder = string_builder + '</div>' # End thumbnail
		string_builder = string_builder + '</div>' # End cols
		return string_builder
	end
	
	
	
	
	
	
end
