$:.push File.expand_path("../../lib", __FILE__)

require 'rubygems'
require 'rspec'

require 'dependor'

RSpec.configure do |c|
  c.color_enabled = true
end
