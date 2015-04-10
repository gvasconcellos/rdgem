require 'rdgem'

module Rdgem
	class Companies
		#queries for a company name. creates when it doesn't exist.
		def self.get_or_create_company(app_key, company)
			org_app_id = false
	
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
	
		#fow now, just used for testing
		def self.delete_company(app_key, company_id)
	
			query = "#{PIPEDRIVE_API}organizations/#{company_id}?#{TOKEN}#{app_key}"
	        response = HTTParty.delete(query)
	
	        return response["success"]
		end
	end
end