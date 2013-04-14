module Dependor::Isolate
  def isolate(&block)
    klass = block.call
    caller_binding = block.binding
    injector = Dependor::EvaluatingInjector.new(caller_binding)
    instantiator = Dependor::Instantiator.new(injector)
    instantiator.instantiate(klass)
  end
end
