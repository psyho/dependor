module Dependor
  module Injectable

    def self.included(klass)
      klass.send(:include, InstanceMethods)
      klass.extend ClassMethods
    end

    module InstanceMethods
      def inject!
        Dependor.injector.inject(self)
      end
    end

    module ClassMethods

      def dependor_meta_data
        @dependor_meta_data ||= Dependor::MetaData.new(self)
      end

      def depends_on(*dependency_names)
        attr_accessor *dependency_names
        dependency_names.each { |name| dependor_meta_data.add_dependency(name) }
      end

      def make
        new.inject!
      end

    end

  end
end
