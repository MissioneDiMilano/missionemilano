class Order < ActiveRecord::Base
    belongs_to :person
    
    def area
       @a ||=  Area.find_by_id(self.companionship_number)
       if (@a.nil?)
          return @a 
       end
       return @a
    end
    
    def area_name
       return area().name 
    end
    
    def area_zone 
       return area().zone 
    end
    
    # returns the count of all the objects in an order hash string.
    def size(hash1=self.orderJSON)
        sum = 0
        unless hash1.class == Hash
            hash1 = eval(hash1)
        end
        hash1.each do |k1,v1|
           v1.each do |k2,v2|
               sum += v2.to_i
           end
        end
        return sum   
    end
    
    def size_remaining
        return size(remainingOrder)
    end
    
    # Will return an Order that is the merge of two passed hashes.
    def combineOrderHash(hash1, hash2)
        unless hash1.class == Hash
            hash1 = eval(hash1)
        end
        
        unless hash2.class == Hash
            hash2 = eval(hash2)
        end
        
        hash3 = hash1.dup
        
        
        hash2.each do |k1,v1|
            v1.each do |k2,v2|
                if hash3[k1].nil?
                   hash3[k1] = Hash.new 
                end
                hash3[k1][k2] = hash3[k1][k2].to_i
                hash3[k1][k2] += v2.to_i
            end
        end
        
        return hash3
         
    end
    
    def remainingOrder
        myOriginal = eval(self.orderJSON)
        
        hisOriginal = eval(self.fulfilledJSON)
        
        combinedOriginal = myOriginal.dup
        
        
        hisOriginal.each do |k1,v1|
            v1.each do |k2,v2|
                combinedOriginal[k1][k2] = combinedOriginal[k1][k2].to_i
                combinedOriginal[k1][k2] -= v2.to_i
                if (combinedOriginal[k1][k2] <= 0)
                   combinedOriginal[k1].except!(k2) # Remove fulfilled item. 
                end
            end
            if (combinedOriginal[k1].count <= 0)
               combinedOriginal.except!(k1) 
            end
        end
        return combinedOriginal
    end
    
    def is_fulfilled?
       order = eval(self.orderJSON)
       fulfilled = eval(self.fulfilledJSON)
       nowFulfilled = true
       order.each do |k1,v1|
          v1.each do |k2,v2|
              if (v2.to_i <= fulfilled[k1][k2].to_i)
                 nowFulfilled = false
                 return nowFulfilled
              end
          end
       end
       return nowFulfilled
    end
    
    # Used to put a hash in a sort of serialized state where it can be saved as text
    # If given the hash {"The Book of Mormon"=>{"English"=>"3", "Italian"=>4}}
    # it will call Hash.inspect yielding "{\"The Book of Mormon\"=>{\"English\"=>\"3\", \"Italian\"=>4}}"
    # It will then call gsub("\"","%kcbDblQt") on that object
    # It should return "{%kcbDblQtThe Book of Mormon%kcbDblQt=>{%kcbDblQtEnglish%kcbDblQt=>%kcbDblQt3%kcbDblQt, %kcbDblQtItalian%kcbDblQt=>4}}"
    def self.serialize_order(order1)
        return order1.inspect().gsub("\"","%kcbDblQt")
    end
    
    def self.deserialize_order(serialized_order1)
        return serialized_order1.gsub("%kcbDblQt","\"")
    end
    
    def deserialize_orders
       self.orderJSON = Order.deserialize_order(self.orderJSON)
       self.fulfilledJSON = Order.deserialize_order(self.fulfilledJSON)
    end
    
    def serialize_orders
        self.orderJSON = serialize_order(self.orderJSON)
       self.fulfilledJSON = serialize_order(self.fulfilledJSON)
    end
    
    def safe_save
        serialize_orders()
        self.save
    end
    
    def is_fulfilled!
       self.fulfilled = is_fulfilled?
    end
    
end
