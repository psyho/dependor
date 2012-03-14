module Dependor
  module Let
    def let(name, &block)
      define_method(name, &block)
    end
  end
end
