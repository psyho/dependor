module Dependor
  class Registry

    def self.class_for_name(class_name)
      parts = class_name.split('::')
      context = Object
      parts.each do |part|
        context = context.const_get(part)
      end
      return context
    end

    attr_reader :dependency_to_class_name_converter

    def initialize(dependency_to_class_name_converter)
      @dependency_to_class_name_converter = dependency_to_class_name_converter
    end

    def object_for_name(name)
      if singleton?(name)
        return singleton_scope[name] ||= new_instance(name)
      else
        return new_instance(name)
      end
    end

    def fake_for_name(name)
      SpyingProxy.new(dependency_klass(name).fake)
    end

    private

    def new_instance(name)
      dependency_klass(name).new
    end

    def singleton_scope
      @singleton_scope ||= {}
    end

    def singleton?(name)
      Dependor::MetaData.for(dependency_klass(name)).scope == :singleton
    end

    def dependency_klass(dependency_name)
      class_name = dependency_to_class_name_converter.convert(dependency_name)
      return self.class.class_for_name(class_name)
    end

  end
end
