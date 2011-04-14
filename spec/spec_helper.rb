$:.push File.expand_path("../../lib", __FILE__)

require 'rubygems'
require 'rspec'

require 'dependor'

require File.expand_path('../sample_classes.rb', __FILE__)

RSpec.configure do |c|
  c.color_enabled = true
end
