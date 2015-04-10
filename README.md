# rdgem
gem to integrate RD and pipedrive

    This is a simple gem to customize a Pipedrive account then add Persons to it.

Usage: Add to your Gemfile

    gem 'rdgem'
    
    bundle install

Methods:

Rdgem::PeopleFields.assert_fields(fields, app_key)

    # Searches the PersonFields for the list of fields requested and return their key.
  
    # Creates the field if nonexistent (using create_field())
  
Rdgem::PeopleFields.create_field(app_key, field_name)

    # adds a new field to the Pipedrive account (will be made private)

Rdgem::Companies.get_or_create_company(app_key, company)

    # Searches the account for the company name and uses it when creating the lead. 
    
    # Creates the organization if nonexistent

Rdgem::People.send_lead(app_key, lead)

    # Posts the info to Pipedrive, if the app_key is valid 
    
Testing only methods (at least up until now)

Rdgem::Companies.delete_company(app_key, company_id)

    # Deletes a company using it's ID
    
Rdgem::PeopleFields.delete_field(app_key, field_id)

    # deletes a field from the Pipedrive account




Based on HTTParty and Pipedrive's API

    https://developers.pipedrive.com/v1
    
