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
  s.summary     = %q{A couple of classes and modules that simplify dependency injection in Ruby.}
  s.description = %q{Dependor is not a framework for Dependency Injection, but something thatt reduces duplication a little bit when doing manual dependency injection in settings like Rails apps.}

  s.rubyforge_project = "dependor"

  s.add_development_dependency 'rspec'

  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'growl'
  s.add_development_dependency 'libnotify'
  s.add_development_dependency 'rake'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
