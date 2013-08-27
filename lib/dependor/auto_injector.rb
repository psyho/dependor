module Dependor
  class AutoInjector

    def initialize(injector, search_modules)
      @injector = injector
      @instantiator = Instantiator.new(self)
      @class_name_resolver = ClassNameResolver.new(search_modules)
    end

    def get(name)
      return @injector.send(name)
    rescue ArgumentError
      return @injector.method(name).to_proc
    rescue NameError
      get_by_class_name(name)
    end

    def get_by_class_name(name)
      ensure_class_exists!(name)
      klass = @class_name_resolver.for_name(name)
      instantiator = @instantiator
      @injector.define_singleton_method(name) do
        instantiator.instantiate(klass)
      end
      @injector.send(name)
    end

    def class_exists?(name)
      !!@class_name_resolver.for_name(name)
    end

    private

    def ensure_class_exists!(name)
      unless class_exists?(name)
        raise UnknownObject.new("Injector does not know how to create object: #{name}")
      end
    end
  end
end
