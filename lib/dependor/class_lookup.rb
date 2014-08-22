module Dependor
  class ClassLookup
    def initialize(modules)
      @modules = modules
    end

    def lookup(class_name)
      class_name = camelize(class_name)
      modules.lazy.map {|m| try_get_class(m, class_name) }.detect{ |klass| klass }
    end

    private

    attr_reader :modules

    def try_get_class(mod, class_name)
      mod.const_get(class_name)
    rescue NameError
    end

    def camelize(name)
      name.to_s.gsub(/^\w/, &:upcase).gsub(/_\w/, &:upcase).gsub('_', '')
    end
  end
end
