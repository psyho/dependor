module Dependor
  class AutoInjector

    attr_reader :injector, :search_modules

    def initialize(injector, search_modules)
      @injector = injector
      @search_modules = search_modules
    end

    def get(name)
      raise UnknownObject.new("Injector does not know how to create object: #{name}") unless resolvable?(name)

      klass = class_for_object_name(name)
      construct_object(klass)
    end

    def resolvable?(name)
      injector.methods.include?(name) || !!class_for_object_name(name)
    end

    private

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

    def construct_object(klass)
      params = klass.instance_method(:initialize).parameters
      dependency_names = params.select{|type, name| type == :req}.map{|type, name| name}
      dependencies = dependency_names.map{|name| injector.send(name)}
      return klass.new(*dependencies)
    end
  end

end
