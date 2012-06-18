module Dependor
  class AutoInjector

    def initialize(injector, search_modules)
      @injector = injector
      @instantiator = Instantiator.new(self)
      @class_name_resolver = ClassNameResolver.new(search_modules)
    end

    def get(name)
      ensure_resolvable!(name)

      if has_method?(name)
        return @injector.send(name) if no_arguments?(name)
        return @injector.method(name).to_proc
      end

      klass = @class_name_resolver.for_name(name)
      @instantiator.instantiate(klass)
    end

    def resolvable?(name)
      has_method?(name) || !!@class_name_resolver.for_name(name)
    end

    private

    def ensure_resolvable!(name)
      unless resolvable?(name)
        raise UnknownObject.new("Injector does not know how to create object: #{name}")
      end
    end

    def has_method?(name)
      @injector.methods.include?(name)
    end

    def no_arguments?(name)
      @injector.method(name).arity == 0
    end

  end

end
