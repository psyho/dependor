require File.expand_path('../../spec_helper.rb', __FILE__)

describe Dependor::Injectable do

  describe ".make" do
    let(:baz) { Baz.make }

    it "should create objects with all dependencies satisfied" do
      baz.bar.should be_an_instance_of(Bar)
    end

    it "should inject every object in the hierarchy" do
      baz.bar.foo.should be_an_instance_of(Foo)
    end

    class DependencyInheritanceParent
      include Dependor::Injectable

      depends_on :foo
    end

    class DependencyInheritanceChild < DependencyInheritanceParent
      depends_on :bar
    end

    it "should inject both inherited and declared dependencies" do
      sample = DependencyInheritanceChild.make

      sample.foo.should be_an_instance_of(Foo)
      sample.bar.should be_an_instance_of(Bar)
    end
  end

  describe ".isolated" do
    let(:baz) { Baz.isolated }

    it "should create an object with all of the dependencies substituted by fakes" do
      baz.bar.should be_an_instance_of(Fake::Bar)
    end
  end

  describe ".fake" do
    it "should return a new fake object" do
      Bar.fake.should be_an_instance_of(Fake::Bar)
    end
  end

  describe "declaring dependencies" do
    class DeclaringDependenciesSample
      include Dependor::Injectable

      depends_on :foo, :bar
      depends_on :baz
    end

    it "should add getters for all of the dependencies" do
      sample = DeclaringDependenciesSample.new

      sample.should respond_to(:foo)
      sample.should respond_to(:bar)
      sample.should respond_to(:baz)
    end

    it "should add getters for all of the dependencies" do
      sample = DeclaringDependenciesSample.new

      sample.should respond_to(:foo=)
      sample.should respond_to(:bar=)
      sample.should respond_to(:baz=)
    end

    class WithAlreadyDefinedGettersAndSetters
      def foo
        return "foo"
      end

      def bar=(new_bar)
        @bar = "prefix_#{new_bar}"
      end

      include Dependor::Injectable

      depends_on :foo, :bar, :baz
    end

    it "should not override already existing getters" do
      sample = WithAlreadyDefinedGettersAndSetters.new

      sample.foo.should == "foo"
    end

    it "should not override already existing setters" do
      sample = WithAlreadyDefinedGettersAndSetters.new

      sample.bar = "bar"

      sample.bar.should == "prefix_bar"
    end
  end

  describe "scoping dependencies" do
    class SampleSingleton
      include Dependor::Injectable

      scope :singleton
    end

    class SamplePrototype
      include Dependor::Injectable

      scope :prototype
    end

    class ScopingExample
      include Dependor::Injectable

      depends_on :sample_singleton, :sample_prototype
    end

    before(:each) do
      @sample_one = ScopingExample.make
      @sample_two = ScopingExample.make
    end

    it "always injects the same instance for singleton scoped classes" do
      @sample_one.sample_singleton.should equal(@sample_two.sample_singleton)
    end

    it "always creates a new instance of the prototype scoped classes" do
      @sample_one.sample_prototype.should_not equal(@sample_two.sample_prototype)
    end
  end

end
