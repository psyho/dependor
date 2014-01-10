require 'spec_helper'

describe Dependor::CustomizedInjector do
  let(:other_injector) { double }

  it "returns the customized dependency if given" do
    injector = Dependor::CustomizedInjector.new(other_injector, foo: 'hello')

    expect(injector.get(:foo)).to eq('hello')
  end

  it "returns the customized dependency even if nil" do
    injector = Dependor::CustomizedInjector.new(other_injector, foo: nil)

    expect(injector.get(:foo)).to be_nil
  end

  it "delegates to the other injector" do
    expect(other_injector).to receive(:get).with(:foo).and_return(:the_foo)

    injector = Dependor::CustomizedInjector.new(other_injector, bar: 'a')

    expect(injector.get(:foo)).to eq(:the_foo)
  end
end
