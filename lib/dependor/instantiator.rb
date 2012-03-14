module Dependor
  class Instantiator
    def initialize(injector)
      @injector = injector
    end

    def instantiate(klass)
      params = klass.instance_method(:initialize).parameters
      dependency_names = params.select{|type, name| type == :req}.map{|type, name| name}
      dependencies = dependency_names.map{|name| @injector.get(name)}
      return klass.new(*dependencies)
    end
  end
end
