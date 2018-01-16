module Dependor
  class Instantiator
    attr_reader :dependency_names

    def initialize(injector, dependency_names)
      @injector = injector
      @dependency_names = dependency_names
      @singletons = {}
    end

    def instantiate(klass)
      dependencies = dependency_names.for_class(klass).map{|name| @injector.get(name)}
      if klass.include?(Dependor::Singleton)
        return @singletons[klass] ||= klass.new(*dependencies)
      else
        return klass.new(*dependencies)
      end
    end
  end
end
