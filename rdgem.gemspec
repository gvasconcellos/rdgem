# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rdgem/version'
require 'rdgem/people'
require 'rdgem/people_fields'
require 'rdgem/companies'

Gem::Specification.new do |spec|
  spec.name          = "rdgem"
  spec.version       = Rdgem::VERSION
  spec.authors       = ["gabriel"]
  spec.email         = ["gfvasconcelos.42@gmail.com"]

  spec.summary       = "leads to pipedrive"
  spec.description   = "gem to import leads into persons"
  spec.homepage      = ""

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_dependency('httparty')
end
