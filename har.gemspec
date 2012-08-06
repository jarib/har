# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "har/version"

Gem::Specification.new do |s|
  s.name        = "har"
  s.version     = HAR::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jari Bakken"]
  s.email       = ["jari.bakken@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Ruby library to work with HTTP archives}
  s.description = %q{Ruby library to work with HTTP archives}

  s.rubyforge_project = "har"

  s.add_dependency "json"
  s.add_dependency "jschematic", ">= 0.1.0"
  s.add_dependency "launchy", ">= 0.3.7"

  s.add_development_dependency "rspec", "~> 2.0"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "rake", "~> 0.9.2"
  s.add_development_dependency "pry"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
