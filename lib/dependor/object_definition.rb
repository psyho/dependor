module Dependor
  ObjectDefinition = Struct.new(:name, :opts, :builder) do
    def self.default_for(klass)
      opts = {transient: Transient.transient?(klass)}
      new(klass.name.to_sym, opts, proc{ new(klass) })
    end

    def singleton?
      !opts[:transient]
    end
  end
end
