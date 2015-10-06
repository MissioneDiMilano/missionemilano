class PdfController < ApplicationController
  def orders
    
    if params.include?(:orders) || true
      
      respond_to do |format|
        format.pdf do
          
          order_ids = params[:orders]
      
          to_print = Order.where(id: [15,17]) 
          
          pdf = Prawn::Document.new
          
          if to_print.count > 1
            # We want a cover page.
            building_hash = Hash.new
            
            
            to_print.each do |order|
              building_hash = order.combineOrderHash(building_hash, order.orderJSON)
            end
            
            total_items = to_print[0].size(building_hash)
            pdf.text total_items.to_s
            
          end
          
          
          to_print.each_with_index do |order, index1|
            #byebug
            # Get companionship number and missionary names.
            area = Area.find(order[:companionship_number])
            area_name = area.name
            
            date = order[:created_at]
            
            pdf.text area_name
            pdf.text date.to_s
            
            orderJSON = eval(order[:orderJSON])
            orderJSON.keys().each do |k|
              pdf.text k
            end
            
            
            pdf.start_new_page
          end
          
          send_data pdf.render, filename: "test.pdf", type: "application/pdf", disposition: "inline"
          
        end
      end
     else 
       # Render error
     end
      
  end
end
