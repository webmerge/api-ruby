# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'web_merge/version'

Gem::Specification.new do |spec|
  spec.name          = "web_merge"
  spec.version       = WebMerge::VERSION
  spec.authors       = ["Jeremy Clarke"]
  spec.email         = ["JeremyClarke@webmerge.me"]
  spec.summary       = %q{WebMerge REST API Wrapper}
  spec.description   = %q{Manage and merge Documents using the WebMerge.me REST API}
  spec.homepage      = "http://www.webmerge.me"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.1'
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "activemodel", ">= 3.0"
end
