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

  it "instantiates objects as a new object" do
    klass = Class.new {}

    first_instance = instantiator.instantiate(klass)
    second_instance = instantiator.instantiate(klass)

    first_instance.object_id.should_not == second_instance.object_id
  end

  it "instantiates objects as a singleton object" do
    klass = Class.new do
      include Dependor::Singleton
    end

    first_instance = instantiator.instantiate(klass)
    second_instance = instantiator.instantiate(klass)

    first_instance.object_id.should == second_instance.object_id
  end
end
