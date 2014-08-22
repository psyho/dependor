module Dependor
  class ObjectNotFound < StandardError
    def initialize(object_name)
      super("Object #{object_name} not found!")
    end
  end
end
