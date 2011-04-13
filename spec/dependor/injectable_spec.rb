require File.expand_path('../../spec_helper.rb', __FILE__)

describe Dependor::Injectable do

  class Foo
    def name
      "world"
    end
  end

  class Fake::Foo
    def name
      "fake"
    end
  end

  class Bar
    include Dependor::Injectable

    depends_on :foo

    def hello
      return "Hello #{foo.name}!"
    end
  end

  class Fake::Bar
    def hello
      "Hello?"
    end
  end

  class Baz
    include Dependor::Injectable

    depends_on :bar
  end

  describe ".make" do
    let(:baz) { Baz.make }

    it "should create objects with all dependencies satisfied" do
      baz.bar.should be_an_instance_of(Bar)
    end

    it "should inject every object in the hierarchy" do
      baz.bar.foo.should be_an_instance_of(Foo)
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
      sample = DependencyInheritanceChild.new

      sample.foo.should be_an_instance_of(Foo)
      sample.bar.should be_an_instance_of(Bar)
    end
  end

end
