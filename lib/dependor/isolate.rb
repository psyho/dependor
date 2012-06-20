module Dependor::Isolate
  def isolate(klass)
    injector = Dependor::SendingInjector.new(self)
    instantiator = Dependor::Instantiator.new(injector)
    instantiator.instantiate(klass)
  end
end
