require 'rdgem'

### Leads integration was  thoroughly tested in the APP

describe Rdgem::PeopleFields do 
	APP_KEY = "e124f874f8b066431f136cc85b07fbaf9a6c7a2b"

	it "fail to add interact with invalid API (fields)" do
		test_resp = Rdgem::PeopleFields.create_field("wrong key",
													 "whatever")
		expect(test_resp).to eql(false)
	end

	it "succeed in adding and removing test fields with valid API" do
		#adding
		fields = [ "field_testing" ]
		add_resp = Rdgem::PeopleFields.assert_fields(fields,
													 APP_KEY,
									   				 testing="create")
		#asserting
		expect(add_resp).not_to eql(false)
		#adding a delay to avoid data-lock from pipedrive
		sleep 1.5
		#removing
		del_resp = Rdgem::PeopleFields.delete_field(APP_KEY,
													add_resp.first)
		#asserting
		expect(del_resp).to eql(true)
	end

	it "asserts default fields that should be there for sure" do
		fields = [ "Name", "ID" ]
		test_resp = Rdgem::PeopleFields.assert_fields(fields, 
													  APP_KEY,
													  testing = "assert")
		expect(test_resp.to_s.downcase).to eql(fields.to_s.downcase)
	end

	it "asserts fields that shouldn't exist" do
		fields = [ "testing_weird_naming_inexistent_field" ]
		test_resp = Rdgem::PeopleFields.assert_fields(fields, 
													  APP_KEY,
													  testing = "assert")
		expect(test_resp).to be_empty
	end
end

describe Rdgem::Companies do 

	it "creates then finds a company using the same function. then deletes" do
		#adding
		create_id = Rdgem::Companies.get_or_create_company(APP_KEY,
													 	  "weird named testing company")
		#asserting
		expect(create_id).not_to eql(false)
		#adding a delay to avoid data-lock from pipedrive
		sleep 1
		# finding it with the same function
		find_id = Rdgem::Companies.get_or_create_company(APP_KEY,
													 	  "weird named testing company")
		sleep 1
		#checking IDs are the same
		create_id.should eq(find_id)
		#removing
		del_resp = Rdgem::Companies.delete_company(APP_KEY,
												   find_id)
		#asserting
		expect(del_resp).to eql(true)
	end
	it "fail to add interact with invalid API (orgs)" do
		test_resp = Rdgem::Companies.get_or_create_company("somekey",
													 	  " company")
		expect(test_resp).to eql(false)
	end
end