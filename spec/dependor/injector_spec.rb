require File.expand_path('../../spec_helper.rb', __FILE__)

describe Dependor::Injector do

  before(:each) do
    @injector = Dependor::Injector.new(Dependor::DependencyToClassNameConverter.new)
  end

  describe "for an instance of a class with no dependencies" do
    class NoDependenciesSample
      attr_accessor :foo
    end

    it "should do nothing" do
      instance = NoDependenciesSample.new

      @injector.inject(instance)

      instance.foo.should be_nil
    end
  end

  describe "for an instance of a class with dependencies" do
    it "should inject those dependencies" do
      bar = Bar.new

      @injector.inject(bar)

      bar.foo.should be_an_instance_of(Foo)
    end
  end

  describe "for a multi-level dependency hierarchy" do
    it "should inject dependencies of dependencies too" do
      baz = Baz.new

      @injector.inject(baz)

      baz.bar.foo.should be_an_instance_of(Foo)
    end
  end

end
