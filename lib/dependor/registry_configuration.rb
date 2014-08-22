module Dependor
  class RegistryConfiguration < BasicObject
    def self.configure(&block)
      configuration = new
      configuration.instance_eval(&block)
      configuration
    end

    attr_reader :__autoinject_modules__, :__definitions__

    def initialize
      @__autoinject_modules__ = []
      @__definitions__ = {}
    end

    def autoinject(mod)
      @__autoinject_modules__ << mod
    end

    def method_missing(name, opts = {}, &block)
      @__definitions__[name] = ObjectDefinition.new(name, opts, block)
    end
  end
end
