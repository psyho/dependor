module Dependor
  module InjectableClass
    attr_accessor :class_takes
    def add_dependencies(*names)
      @class_takes = names
    end
  end
end
