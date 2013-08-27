module Dependor
  class Instantiator
    attr_reader :dependency_names

    def initialize(injector, dependency_names)
      @injector = injector
      @dependency_names = dependency_names
    end

    def instantiate(klass)
      dependencies = dependency_names.for_class(klass).map{|name| @injector.get(name)}
      return klass.new(*dependencies)
    end
  end
end
