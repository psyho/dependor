module Dependor
  class AutoInjector

    def initialize(injector, search_modules)
      @injector = injector
      @instantiator = Instantiator.new(self)
      @class_name_resolver = ClassNameResolver.new(search_modules)
    end

    def get(name)
      ensure_resolvable!(name)

      return @injector.send(name) if method_exists?(name)

      klass = @class_name_resolver.for_name(name)
      @instantiator.instantiate(klass)
    end

    def resolvable?(name)
      method_exists?(name) || !!@class_name_resolver.for_name(name)
    end

    private

    def ensure_resolvable!(name)
      unless resolvable?(name)
        raise UnknownObject.new("Injector does not know how to create object: #{name}")
      end
    end

    def method_exists?(name)
      @injector.methods.include?(name)
    end

  end

end
