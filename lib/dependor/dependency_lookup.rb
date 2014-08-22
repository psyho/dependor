module Dependor
  class DependencyLookup
    def self.for_class(klass)
      return [] unless klass.respond_to?(:takes)
      klass.takes
    end
  end
end
