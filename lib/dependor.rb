require 'dependor/injectable.rb'
require 'dependor/meta_data.rb'
require 'dependor/injector.rb'
require 'dependor/dependency_to_class_name_converter.rb'

module Dependor
  def self.dependency_to_class_name_converter
    @dependency_to_class_name_converter ||= DependencyToClassNameConverter.new
  end

  def self.injector
    @injector ||= Injector.new(dependency_to_class_name_converter)
  end
end

module Fake
end
