module AdminHelper
	
	
	
	def getTitleForPersonType(type)
		
		@person_types.each_with_index do |t, index|
			
			if t[1]["user_type_number"] == type
				
				return t[0]
			end
		end
		return "Unknown"
	end
	
end