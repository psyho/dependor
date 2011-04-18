module Dependor
  class Injector

    attr_reader :registry

    def initialize(registry)
      @registry = registry
    end

    def inject(instance)
      return set_dependencies(instance) do |dependency_name|
        dependency = registry.object_for_name(dependency_name)
        inject(dependency)
      end
    end

    def isolate(instance)
      return set_dependencies(instance) do |dependency_name|
        registry.fake_for_name(dependency_name)
      end
    end

    private

    def set_dependencies(instance, &block)
      meta_data = Dependor::MetaData.for(instance)

      meta_data.dependencies.each do |dependency_name|
        dependency = block.call(dependency_name)

        instance.send("#{dependency_name}=", dependency)
      end

      return instance
    end

  end
end
