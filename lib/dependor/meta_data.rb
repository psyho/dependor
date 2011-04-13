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
      @dependencies + superclass_dependencies
    end

    def self.for(klass)
      if klass.respond_to?(:dependor_meta_data)
        return klass.dependor_meta_data
      else
        return EmptyMetaData.new
      end
    end

    private

    def superclass_dependencies
      self.class.for(@klass.superclass).dependencies
    end
  end

  class EmptyMetaData
    def dependencies
      Set.new
    end
  end

end
