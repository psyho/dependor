module Dependor
  module AutoInject

    module ClassMethods
      def look_in_modules(*modules)
        search_modules.concat(modules)
      end

      def search_modules
        @search_modules ||= []
      end
    end

    def self.included(klass)
      klass.extend ClassMethods
    end

    def method_missing(name, *args, &block)
      auto_injector.get(name)
    end

    def respond_to?(name)
      auto_injector.resolvable?(name)
    end

    private

    def auto_injector
      @auto_injector ||= Dependor::AutoInjector.new(self, self.class.search_modules)
    end

  end

end

