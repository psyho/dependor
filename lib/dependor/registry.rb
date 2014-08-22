module Dependor
  class Registry
    def self.build(&block)
      registry = new
      registry.configure(&block)
      registry
    end

    def initialize
      @autoinject_modules = []
      @definitions = {}
      @objects = {}
    end

    def configure(&block)
      configuration = RegistryConfiguration.configure(&block)
      @autoinject_modules += configuration.__autoinject_modules__
      @definitions = definitions.merge(configuration.__definitions__)
    end

    def [](name)
      return @objects[name] if @objects.key?(name)
      definition = fetch_definition(name)
      object = instantiator.instantiate(definition)
      @objects[name] = object if definition.singleton?
      object
    end

    private

    def fetch_definition(name)
      return definitions[name] if definitions.key?(name)
      klass = class_lookup.lookup(name)
      return ObjectDefinition.default_for(klass) if klass
      raise ObjectNotFound.new(name)
    end

    def class_lookup
      ClassLookup.new(autoinject_modules)
    end

    def instantiator
      Instantiator.new(class_lookup, self)
    end

    attr_reader :autoinject_modules, :definitions
  end
end
