require 'spec_helper'

describe Dependor::CustomizedInjector do
  let(:other_injector) { stub }

  it "returns the customized dependency if given" do
    injector = Dependor::CustomizedInjector.new(other_injector, foo: 'hello')

    injector.get(:foo).should == 'hello'
  end

  it "returns the customized dependency even if nil" do
    injector = Dependor::CustomizedInjector.new(other_injector, foo: nil)

    injector.get(:foo).should be_nil
  end

  it "delegates to the other injector" do
    other_injector.should_receive(:get).with(:foo).and_return(:the_foo)

    injector = Dependor::CustomizedInjector.new(other_injector, bar: 'a')

    injector.get(:foo).should == :the_foo
  end
end
