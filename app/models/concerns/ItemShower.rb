module ItemShower
    extend ActiveSupport::Concern
    
    def return_item_thumbnail(picture_url, title, element_class)
        string_builder = ""
        string_builder = string_builder + '<div class="col-xs-4 col-md-2">'
        string_builder = string_builder + '<div class="thumbnail select-component '+element_blass+'">'
        string_builder = string_builder + '<img src="'+picture_url+'">'
        string_builder = string_builder + '<div class="caption"><h5>'+title+'</h5></div>'
        string_builder = string_builder + '</div>' # End thumbnail
        string_builder = string_builder + '</div>' # End cols
        return string_builder
    end
    
end
