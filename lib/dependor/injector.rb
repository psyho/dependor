module Dependor
  class Injector

    attr_reader :dependency_to_class_name_converter

    def initialize(dependency_to_class_name_converter)
      @dependency_to_class_name_converter = dependency_to_class_name_converter
    end

    def inject(instance)
      meta_data = Dependor::MetaData.for(instance)

      meta_data.dependencies.each do |dependency_name|
        klass = class_for_name(dependency_name)
        dependency = inject(klass.new)
        instance.send("#{dependency_name}=", dependency)
      end

      return instance
    end

    private

    def class_for_name(dependency_name)
      class_name = dependency_to_class_name_converter.convert(dependency_name)
      parts = class_name.split('::')
      context = Object
      parts.each do |part|
        context = context.const_get(part)
      end
      return context
    end

  end
end
