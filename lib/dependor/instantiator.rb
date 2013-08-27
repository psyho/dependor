module Dependor
  class Instantiator
    def initialize(injector)
      @injector = injector
      @constructor_params = {}
    end

    def instantiate(klass)
      dependencies = dependecy_names_for(klass).map{|name| @injector.get(name)}
      return klass.new(*dependencies)
    end

    private

    def dependecy_names_for(klass)
      @constructor_params[klass] ||= get_constructor_params(klass)
    end

    def get_constructor_params(klass)
      params = klass.instance_method(:initialize).parameters
      params.select{|type, name| type == :req}.map{|type, name| name}
    end
  end
end
