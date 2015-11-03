require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'
require 'zlib'
require 'stringio'

class PdfController < ApplicationController
  def orders
    
    if params.include?(:orders) || true
      
      respond_to do |format|
        format.pdf do
          
          order_ids = params[:orders]
          order_ids = [15,17]
          to_print = Order.where(id: order_ids) 
          
          
          
          pdf = Prawn::Document.new
          

          
          if to_print.count > 1
            
            # We want a cover page.
            
            crc = Zlib.crc32(order_ids.sort.join(","))
            
            building_hash = Hash.new
            
            barcodeTest = Barby::Code128B.new(crc.to_s)

            pdf.image StringIO.new(Barby::PngOutputter.new(barcodeTest).to_png), :position => :right
            
            to_print.each do |order|
              building_hash = order.combineOrderHash(building_hash, order.orderJSON)
            end
            
            
            pdf.text "Order ID: "+crc.to_s, :align => :right
            pdf.move_up 100
            total_items = to_print[0].size(building_hash)
            pdf.text "Total items: " + total_items.to_s
            pdf.move_down 10
            building_hash.each do |k1,v1|
              v1.each do |k2,v2|
               pdf.text v2.to_s + " x " + k1.to_s + " in "+k2.to_s 
              end
            end
            pdf.start_new_page
          end
          
          # TODO make sorting algorithm here.
          
          to_print.each_with_index do |order, index1|
            #byebug
            # Get companionship number and missionary names.
            area = Area.find(order[:companionship_number])
            area_name = area.name
            
            date = order[:created_at]
            
            pdf.text area_name
            pdf.text date.to_s
            
            # no longer necessary since the introduction of hstore Oct 2, 2015
            #orderJSON = eval(order[:orderJSON])
            
            
            orderJSON.each do |k1,v1|
              v1.each do |k2,v2|
               pdf.text v2.to_s + " x " + k1.to_s + " in "+k2.to_s 
              end
            end
            
            unless index1 == to_print.count-1
              pdf.start_new_page
            end
          end
          
          send_data pdf.render, filename: "test.pdf", type: "application/pdf", disposition: "inline"
          
        end
      end
     else 
       # Render error
     end
      
  end
end
