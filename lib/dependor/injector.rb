module Dependor
  class Injector

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

    def inject(instance)
      return set_dependencies(instance) { |dependency_klass| inject(dependency_klass.new) }
    end

    def isolate(instance)
      return set_dependencies(instance) { |dependency_klass| SpyingProxy.new(dependency_klass.fake) }
    end

    private

    def set_dependencies(instance, &block)
      meta_data = Dependor::MetaData.for(instance)

      meta_data.dependencies.each do |dependency_name|
        class_name = dependency_to_class_name_converter.convert(dependency_name)
        klass = self.class.class_for_name(class_name)

        dependency = block.call(klass)

        instance.send("#{dependency_name}=", dependency)
      end

      return instance
    end

  end
end
