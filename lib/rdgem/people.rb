require 'rdgem'

module Rdgem
	class People
		#pushes the lead to pipedrive
  		def self.send_lead(app_key, lead_to_person)
	    	query = PIPEDRIVE_API + 'persons?' + TOKEN + app_key

    		response = HTTParty.post(query,
    					:body => lead_to_person,
    					:headers => HEADERS)
    		return response["success"]
	  end
	end
end