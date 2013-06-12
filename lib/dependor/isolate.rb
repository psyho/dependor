module Dependor
  module Isolate
    def isolate(klass = nil, overrides = {}, &block)
      if block_given?
        klass = block.call
        caller_binding = block.binding
        injector = EvaluatingInjector.new(caller_binding)
      else
        sending_injector = SendingInjector.new(self)
        injector = CustomizedInjector.new(sending_injector, overrides)
      end
      instantiator = Instantiator.new(injector)
      instantiator.instantiate(klass)
    end
  end
end
