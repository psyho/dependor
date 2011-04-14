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
  end

  describe "dependency inheritance" do
    class DependencyInheritanceParent
      include Dependor::Injectable

      depends_on :foo
    end

    class DependencyInheritanceChild < DependencyInheritanceParent
      depends_on :bar
    end

    it "should inject both parent and child dependencies" do
      sample = DependencyInheritanceChild.make

      sample.foo.should be_an_instance_of(Foo)
      sample.bar.should be_an_instance_of(Bar)
    end
  end

end
