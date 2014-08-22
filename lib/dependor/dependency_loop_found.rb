module Dependor
  class DependencyLoopFound < StandardError
    def initialize(lookup)
      super("Dependency loop found: #{lookup}")
    end
  end
end
