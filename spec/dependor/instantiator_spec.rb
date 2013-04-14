require 'spec_helper'

describe Dependor::Instantiator do
  let(:injector) { stub(:injector) }
  let(:instantiator) { Dependor::Instantiator.new(injector) }

  it "instantiates objects with no-arg constructors" do
    klass = Class.new do
      def foo
        "foo"
      end
    end

    instance = instantiator.instantiate(klass)
    instance.foo.should == "foo"
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

    injector.should_receive(:get).with(:foo).and_return("foo")
    injector.should_receive(:get).with(:bar).and_return("bar")
    injector.should_receive(:get).with(:baz).and_return("baz")

    instance = instantiator.instantiate(klass)

    instance.foo.should == 'foo-bar-baz'
  end
end
