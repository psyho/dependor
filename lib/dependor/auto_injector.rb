module Dependor
  class AutoInjector

    attr_reader :injector, :search_modules

    def initialize(injector, search_modules)
      @injector = injector
      @search_modules = search_modules
      @instantiator = Instantiator.new(self)
    end

    def get(name)
      return injector.send(name) if method_exists?(name)
      raise UnknownObject.new("Injector does not know how to create object: #{name}") unless resolvable?(name)

      klass = class_for_object_name(name)
      @instantiator.instantiate(klass)
    end

    def resolvable?(name)
      method_exists?(name) || !!class_for_object_name(name)
    end

    private

    def method_exists?(name)
      injector.methods.include?(name)
    end

    def camelize(symbol)
      string = symbol.to_s
      string = string.gsub(/_\w/) { |match| match[1].upcase }
      return string.gsub(/^\w/) { |match| match.upcase }
    end

    def class_for_object_name(name)
      class_name = camelize(name)
      modules = [Object, self].concat(search_modules)
      klass = nil

      modules.each do |mod|
        klass = mod.const_get(class_name) rescue nil
        break if klass
      end

      klass
    end

  end

end
