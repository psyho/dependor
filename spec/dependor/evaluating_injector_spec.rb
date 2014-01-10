require 'spec_helper'

describe Dependor::EvaluatingInjector do
  it 'evaluates methods in given binding' do
    def baz
      "the method baz"
    end

    injector = Dependor::EvaluatingInjector.new(binding)

    expect(injector.get(:baz)).to eq("the method baz")
  end

  it 'evaluates local variables in given binding' do
    bar = "the local bar"

    injector = Dependor::EvaluatingInjector.new(binding)

    expect(injector.get(:bar)).to eq("the local bar")
  end
end
