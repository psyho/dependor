require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter]

SimpleCov.start do
  add_filter "/spec/"
end

$:.push File.expand_path("../../lib", __FILE__)

require 'rubygems'
require 'rspec'

require 'dependor'
require 'dependor/shorty'
