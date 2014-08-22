module Dependor
  class Instantiator < BasicObject
    def initialize(class_lookup, injector)
      @class_lookup = class_lookup
      @injector = injector
    end

    def instantiate(definition)
      instance_exec(&definition.builder)
    end

    def new(klass_name, overwrites = {})
      klass = @class_lookup.lookup(klass_name)
      dependencies = DependencyLookup.for_class(klass)
      return klass.new if dependencies.empty?
      args = {}
      dependencies.each do |name|
        args[name] = overwrites.fetch(name) { @injector[name] }
      end
      klass.new(args)
    end

    def method_missing(name, *args, &block)
      super if args.any?
      @injector[name]
    end
  end
end
