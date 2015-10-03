class PdfController < ApplicationController
  def orders
    
    if params.include?(:orders) || true
      
      order_ids = params[:orders]
      
      to_print = Order.where(id: [13]) 
      
      respond_to do |format|
        format.pdf do
          pdf = Prawn::Document.new
          
          to_print.each_with_index do |order, index1|
            byebug
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
          
          send_data pdf.render, filename: "test.pdf", type: "application/pdf"
          
        end
      end
     else 
       # Render error
     end
      
  end
end
