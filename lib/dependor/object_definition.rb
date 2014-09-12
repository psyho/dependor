module Dependor
  ObjectDefinition = Struct.new(:name, :opts, :builder) do
    def self.default_for(klass)
      opts = {transient: Transient.transient?(klass)}
      new(klass.name.to_sym, opts, proc{ new(klass) })
    end

    def self.build(name, transient: false, as: :instance, &block)
      if as == :class
        block ||= proc{ get_class(name) }
      end
      block ||= proc{ new(name) }
      new(name, {transient: transient}, block)
    end

    def singleton?
      !opts[:transient]
    end
  end
end
