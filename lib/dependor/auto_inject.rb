module Dependor
  module AutoInject

    class UnknownObject < StandardError; end

    def self.included(klass)
      klass.extend ClassMethods
    end

    def method_missing(name, *args, &block)
      raise UnknownObject.new("Injector does not know how to create object: #{name}") unless respond_to?(name)

      klass = PrivateMethods.class_for_object_name(name, self.class.search_modules)
      PrivateMethods.construct_object(klass, self)
    end

    def respond_to?(name)
      super || !!PrivateMethods.class_for_object_name(name, self.class.search_modules)
    end

    module ClassMethods
      def look_in_modules(*modules)
        search_modules.concat(modules)
      end

      def search_modules
        @search_modules ||= []
      end
    end

    module PrivateMethods
      def camelize(symbol)
        string = symbol.to_s
        string = string.gsub(/_\w/) { |match| match[1].upcase }
        return string.gsub(/^\w/) { |match| match.upcase }
      end

      def class_for_object_name(name, search_modules)
        class_name = camelize(name)
        modules = [Object, self].concat(search_modules)
        klass = nil

        modules.each do |mod|
          klass = mod.const_get(class_name) rescue nil
          break if klass
        end

        klass
      end

      def construct_object(klass, injector)
        params = klass.instance_method(:initialize).parameters
        dependency_names = params.select{|type, name| type == :req}.map{|type, name| name}
        dependencies = dependency_names.map{|name| injector.send(name)}
        return klass.new(*dependencies)
      end

      extend self
    end
  end

end

