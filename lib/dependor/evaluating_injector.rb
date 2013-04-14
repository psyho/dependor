class Dependor::EvaluatingInjector
  def initialize(binding)
    @binding = binding
  end

  def get(name)
    @binding.eval(name.to_s)
  end
end
