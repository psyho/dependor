require 'dependor/injectable.rb'
require 'dependor/meta_data.rb'
require 'dependor/injector.rb'
require 'dependor/dependency_to_class_name_converter.rb'
require 'dependor/spying_proxy.rb'
require 'dependor/registry.rb'

module Dependor

  def self.dependency_to_class_name_converter
    @dependency_to_class_name_converter ||= DependencyToClassNameConverter.new
  end

  def self.registry
    @registry ||= Registry.new(dependency_to_class_name_converter)
  end

  def self.injector
    @injector ||= Injector.new(registry)
  end

end

module Fake
end
