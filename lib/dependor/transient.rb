module Dependor
  module Transient
    def self.transient?(klass)
      self > klass.singleton_class
    end
  end
end
