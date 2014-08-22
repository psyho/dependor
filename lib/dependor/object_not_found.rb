module Dependor
  class ObjectNotFound < StandardError
    def initialize(lookup)
      super("Object #{lookup.current} not found! (#{lookup})")
    end
  end
end
