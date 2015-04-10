require "rdgem/version"
require "rdgem/people_fields"
require "rdgem/companies"
require "rdgem/people"

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

end