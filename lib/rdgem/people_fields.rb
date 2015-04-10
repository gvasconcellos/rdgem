require 'rdgem'

module Rdgem
	class PeopleFields

	## even if populated the field key will always be replaced
	def self.create_field(app_key, field_name, testing=0)
		field_api_key = false
		field_api_id = false

		input_query = PIPEDRIVE_API + 'personFields?' + TOKEN + app_key

        response = HTTParty.post(input_query, 
        				:body => {:name =>"#{field_name}",
        				:field_type => "varchar"},
        				:headers => HEADERS )

         unless response["data"] == nil
           	field_api_id = response["data"]["id"]


           	#for testing we just need the ID to delete it right away
           	if testing == "create"
           		return field_api_id
           	end

           	key_query = PIPEDRIVE_API + 'personFields/'\
            			+ field_api_id.to_s + "?" + TOKEN + app_key

            field_key_response = HTTParty.get(key_query)

            unless field_key_response["data"] == nil
           		field_api_key = field_key_response["data"]["key"]
  			end
        end
        return field_api_key
	end

	#checks if the key is valid and if the custom fields are created in the acc
	# if any field is missing, create it
	def self.assert_fields(fields, app_key, testing=0)
		@field_key = []
        query = PIPEDRIVE_API + 'personFields?' + TOKEN + app_key

      	response = HTTParty.get(query)
      	if response["success"]
      		#Assert: looks for the desired fields
      		fields.each_with_index do |assert, index|
		    	response["data"].each do |search|
	      			if search['name'] == assert
		      			@field_key[index] = search['key']
      				end
      			end
    		end
    		if testing == "assert"
    			return @field_key
    		end

    		# Integrate: create missing fields
    		fields.each_with_index do |create, index|
    			if @field_key[index].nil?
    				@field_key[index] = create_field(app_key, create, testing)
    			end
    		end
    		if testing == "create"
    			return @field_key
    		end
    		 
      		#Hash the info
    		custom_field = Hash[fields.zip(@field_key.map \
      			{|i| i.include?(',') ? (i.split /, /) : i})] #/
    	else
    		if response["error"] == "You need to be authorized to make this request."
    			return false
    		end
    	end
    	#ship it back
    	return custom_field
    end

	# removes a field from the owner app_key's account (used for testing only)
	def self.delete_field(app_key, field_id)

		query = "#{PIPEDRIVE_API}personFields/#{field_id}?#{TOKEN}#{app_key}"
        response = HTTParty.delete(query)

        return response["success"]
	end

	end
end