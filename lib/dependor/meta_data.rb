module Dependor

  class MetaData
    def initialize(klass)
      @dependencies = Set.new
      @klass = klass
    end

    def add_dependency(name)
      @dependencies.add(name)
    end

    def dependencies
      @dependencies + super_meta_data.dependencies
    end

    attr_writer :scope

    def scope
      @scope || super_meta_data.scope
    end

    def self.for(klass)
      if klass.respond_to?(:dependor_meta_data)
        return klass.dependor_meta_data
      elsif !klass.is_a?(Class)
        return self.for(klass.class)
      else
        return EmptyMetaData.new
      end
    end

    private

    def super_meta_data
      self.class.for(@klass.superclass)
    end

  end

  class EmptyMetaData
    def dependencies
      Set.new
    end

    def scope
      :prototype
    end
  end

end
