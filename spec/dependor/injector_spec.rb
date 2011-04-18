require File.expand_path('../../spec_helper.rb', __FILE__)

describe Dependor::Injector do

  before(:each) do
    dependency_to_class_name_converter = Dependor::DependencyToClassNameConverter.new
    registry = Dependor::Registry.new(dependency_to_class_name_converter)
    @injector = Dependor::Injector.new(registry)
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

  describe "isolated dependencies" do
    it "should allow spying on them" do
      bar = Bar.isolated

      bar.hello # calls foo.name internally

      bar.foo.__method_calls__.should include([:name, []])
    end
  end

  describe "fancy rspec matcher for spying on fakes" do

    require 'dependor/rspec_mathers.rb'
    include Dependor::RSpecMatchers

    before(:each) do
      @foo = Bar.isolated.foo
    end

    it "should allow asserting that a method was called" do
      @foo.do_stuff(:one, :two)

      @foo.should have_received.do_stuff(:one, :two)
    end

    it "should allow asserting that a method was not called" do
      @foo.do_stuff(:one, :two)

      @foo.should_not have_received.name
      @foo.should_not have_received.do_stuff(:one)
    end
  end

end
