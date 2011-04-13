# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dependor/version"

Gem::Specification.new do |s|
  s.name        = "dependor"
  s.version     = Dependor::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Adam Pohorecki"]
  s.email       = ["adam@pohorecki.pl"]
  s.homepage    = "http://github.com/psyho/dependor"
  s.summary     = %q{A simple, setter-based dependency injection framework}
  s.description = %q{A framework for doing Dependency Injection in environments non-ioc-container friendly, like Rails. It allows you to write much faster, truly unit tests.}

  s.rubyforge_project = "dependor"

  s.add_development_dependency 'rspec'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
