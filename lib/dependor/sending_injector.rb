class Dependor::SendingInjector
  def initialize(context)
    @context = context
  end

  def get(name)
    @context.__send__(name)
  end
end
