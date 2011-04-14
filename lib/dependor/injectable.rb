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

      def isolate!
        Dependor.injector.isolate(self)
      end

    end

    module ClassMethods

      def dependor_meta_data
        @dependor_meta_data ||= Dependor::MetaData.new(self)
      end

      def depends_on(*dependency_names)
        dependency_names.each do |dependency_name|
          attr_reader dependency_name unless instance_methods.include?(dependency_name)
          attr_writer dependency_name unless instance_methods.include?(:"#{dependency_name}=")
        end

        dependency_names.each { |name| dependor_meta_data.add_dependency(name) }
      end

      def make
        new.inject!
      end

      def fake
        Injector.class_for_name("Fake::#{name}").new
      end

      def isolated
        new.isolate!
      end

    end

  end
end
