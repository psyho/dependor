module Dependor
  class DependencyNamesCache
    def initialize
      @constructor_params = {}
    end

    def for_class(klass)
      @constructor_params[klass] ||= get_constructor_params(klass)
    end

    private

    def get_constructor_params(klass)
      params = klass.instance_method(:initialize).parameters
      params.select{|type, name| type == :req}.map{|type, name| name}
    end
  end
end
