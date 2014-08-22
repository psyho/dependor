module Dependor
  module Injectable
    def self.included(klass)
      klass.extend(Takes)
    end

    def initialize(dependencies = {})
      takes = self.class.takes

      missing = takes - dependencies.keys
      extra = dependencies.keys - takes
      raise ArgumentError, "Missing arguments: #{missing.join(', ')}" if missing.any?
      raise ArgumentError, "Unknown arguments passed: #{extra.join(', ')}" if extra.any?

      takes.each do |name|
        instance_variable_set("@#{name}", dependencies.fetch(name))
      end
    end

    module Takes
      def takes(*dependency_names)
        @takes ||= []

        if dependency_names.empty?
          parent_takes = superclass.takes if superclass.respond_to?(:takes)
          parent_takes ||= []
          return @takes + parent_takes
        else
          @takes += dependency_names
          attr_reader(*dependency_names)
        end
      end
    end
  end
end
