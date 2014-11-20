require 'spec_helper'

describe Dependor::Instantiator do
  let(:injector) { double(:injector) }
  let(:dependency_names) { Dependor::DependencyNamesCache.new }
  let(:instantiator) { Dependor::Instantiator.new(injector, dependency_names) }

  it "instantiates objects with no-arg constructors" do
    klass = Class.new do
      def foo
        "foo"
      end
    end

    instance = instantiator.instantiate(klass)
    expect(instance.foo).to eq("foo")
  end

  it "instantiates objects with constructors" do
    klass = Class.new do
      def initialize(foo, bar, baz)
        @foo = [foo, bar, baz].join('-')
      end

      def foo
        @foo
      end
    end

    expect(injector).to receive(:get).with(:foo).and_return("foo")
    expect(injector).to receive(:get).with(:bar).and_return("bar")
    expect(injector).to receive(:get).with(:baz).and_return("baz")

    instance = instantiator.instantiate(klass)

    expect(instance.foo).to eq('foo-bar-baz')
  end
end
