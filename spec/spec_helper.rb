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

spec_support_dir = File.expand_path("../support", __FILE__)

Dir["#{spec_support_dir}/**/*.rb"].each do |file|
  require file
end

require 'dependor'
require 'dependor/core_ext'
