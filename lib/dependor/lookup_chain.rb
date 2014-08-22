module Dependor
  class LookupChain
    def initialize(names = [])
      @names = names
    end

    def current
      names.last
    end

    def copy_and_clear
      lookup_chain = copy
      clear
      lookup_chain
    end

    def start(name)
      ensure_no_loop!(name)
      names.push(name)
    end

    def finish
      names.pop
    end

    def to_s
      names.join(' -> ')
    end

    private

    def ensure_no_loop!(name)
      return unless names.include?(name)
      raise DependencyLoopFound.new(copy_and_clear)
    end

    def copy
      self.class.new(names)
    end

    def clear
      @names = []
    end

    attr_reader :names
  end
end
