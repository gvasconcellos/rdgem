require "rdgem/version"

require 'json'
require 'httparty'

module Rdgem
  # Your code goes here...
  # global declarations
  	PIPEDRIVE_API = "https://api.pipedrive.com/v1/"
	TOKEN = "api_token="
	HEADERS = {'Accept'=>'application/json',
               'Content-Type'=>'application/x-www-form-urlencoded',
               'User-Agent'=>'Ruby.Pipedrive.Api' }

    #pushes the lead to pipedrive
  	def self.send_lead(app_key, lead_to_person)
    	query = PIPEDRIVE_API + 'persons?' + TOKEN + app_key

    	response = HTTParty.post(query,
    				:body => lead_to_person,
    				:headers => HEADERS)
	end

	#queries for a company name. creates when it doesn't exist.
	def self.get_or_create_company(app_key, company)
		org_app_id = ""

		query = PIPEDRIVE_API + 'organizations/find?term=' \
            + company + '&start=0&' + TOKEN + app_key

        response = HTTParty.get(query)
        #if successfull and with content, get the company app_key
        #so as not to create another with the same name
        if response["success"]
          unless response["data"] == nil
            response["data"].each do |search|
              if search['name'] == company
                org_app_id = search['id']
                #not caring about duplicates. 
                #we will ensure we at least won't create any
                break
              end
            end
          else
            #didn't find, create one
			input_query = PIPEDRIVE_API + 'organizations?' + TOKEN + app_key

        	org_response = HTTParty.post(input_query, 
          					:body => {:name =>company},
          					:headers => HEADERS )

            unless org_response["data"] == nil
            	org_app_id = org_response["data"]["id"]
            end
          end
        else
          #error getting company
        end
        return org_app_id
	end

	# adds a new field to the owner app_key's account
	def self.add_field_to_user(app_key, field_name)
		field_api_key = false

		input_query = PIPEDRIVE_API + 'personFields?' + TOKEN + app_key

        response = HTTParty.post(input_query, 
        			:body => {:name =>"#{field_name}", 
        			:field_type => "varchar"},
        			:headers => HEADERS )

         unless response["data"] == nil
           	field_api_id = response["data"]["id"]

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
	def self.assert_fields(fields, app_key)
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

    		# Integrate: create missing fields
    		fields.each_with_index do |create, index|
    			if @field_key[index].blank?
    				@field_key[index] = create_field(app_key, create)
    			end
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
	
	## even if populated the field key will always be replaced
	def self.create_field(app_key, field_name)
		field_api_key = false

		input_query = PIPEDRIVE_API + 'personFields?' + TOKEN + app_key

        response = HTTParty.post(input_query, 
        				:body => {:name =>"#{field_name}",
        				:field_type => "varchar"},
        				:headers => HEADERS )

         unless response["data"] == nil
           	field_api_id = response["data"]["id"]

           	key_query = PIPEDRIVE_API + 'personFields/'\
            			+ field_api_id.to_s + "?" + TOKEN + app_key

            field_key_response = HTTParty.get(key_query)

            unless field_key_response["data"] == nil
           		field_api_key = field_key_response["data"]["key"]
  			end
        end
        return field_api_key
	end
end