module Dependor
  class ClassNameResolver
    attr_reader :search_modules

    def initialize(search_modules)
      @search_modules = search_modules
    end

    def for_name(name)
      class_name = camelize(name)
      modules = search_modules + [Object]
      klass = nil

      modules.each do |mod|
        klass = mod.const_get(class_name) rescue nil
        break if klass
      end

      klass
    end

    private

    def camelize(symbol)
      string = symbol.to_s
      string = string.gsub(/_\w/) { |match| match[1].upcase }
      return string.gsub(/^\w/) { |match| match.upcase }
    end
  end
end
