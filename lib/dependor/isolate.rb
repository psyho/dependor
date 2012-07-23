module Dependor::Isolate
  def isolate(klass, overrides = {})
    injector = Dependor::SendingInjector.new(self)
    customized_injector = Dependor::CustomizedInjector.new(injector, overrides)
    instantiator = Dependor::Instantiator.new(customized_injector)
    instantiator.instantiate(klass)
  end
end
