require 'spec_helper'

require 'dependor/shorty'

describe Dependor::AutoInject do
  class SampleClassWithNoDependencies
  end

  class SampleClassWithDependency
    takes :sample_class_with_no_dependencies
  end

  class SampleClassWithManualDependency
    takes :manual_dep
  end

  class DependsOnFactoryMethod
    takes :create_foo
  end

  module SomeModule
    class SampleClassWithinSomeModule
    end
  end

  class SomeFactory
    attr_reader :foo, :sample_class_with_no_dependencies

    def initialize(foo, sample_class_with_no_dependencies)
      @foo = foo
      @sample_class_with_no_dependencies = sample_class_with_no_dependencies
    end
  end

  class SampleInjector
    include Dependor::AutoInject
    look_in_modules SomeModule

    def manual_dep
      "manual dep"
    end

    def create_foo(foo_name)
      inject(SomeFactory, foo: foo_name)
    end
  end

  let(:injector) { SampleInjector.new }

  shared_examples_for 'dependency injector' do
    it 'responds to the object name' do
      expect(injector).to respond_to(object_name)
    end

    it 'creates the object' do
      expect(injector.send(object_name)).to be_an_instance_of(object_class)
    end
  end

  context 'no dependencies' do
    let(:object_name) { :sample_class_with_no_dependencies }
    let(:object_class) { SampleClassWithNoDependencies }

    it_behaves_like 'dependency injector'
  end

  context 'dependencies on other objects' do
    let(:object_name) { :sample_class_with_dependency }
    let(:object_class) { SampleClassWithDependency }

    it_behaves_like 'dependency injector'
  end

  context 'dependencies on objects returned by methods on the injector' do
    let(:object_name) { :sample_class_with_manual_dependency }
    let(:object_class) { SampleClassWithManualDependency }

    it_behaves_like 'dependency injector'
  end

  context 'dependencies from another module' do
    let(:object_name) { :sample_class_within_some_module }
    let(:object_class) { SomeModule::SampleClassWithinSomeModule }

    it_behaves_like 'dependency injector'
  end

  context 'autoinjecting with custom dependencies' do
    it "injects the dependencies which are not explicitly specified" do
      expect(injector.create_foo("the foo name").sample_class_with_no_dependencies).to be_an_instance_of(SampleClassWithNoDependencies)
    end

    it "passes through the dependencies that were specified" do
      expect(injector.create_foo("the foo name").foo).to eq("the foo name")
    end
  end

  context 'injecting factory methods' do
    it "injects factory methods as procs" do
      object = injector.depends_on_factory_method

      expect(object.create_foo.call("test").foo).to eq("test")
    end
  end

  it "raises an error if the object is not found" do
    expect{ injector.unknown_object }.to raise_exception(Dependor::UnknownObject)
  end

  it 'responds to regular methods on injector' do
    expect(injector).to respond_to(:manual_dep)
  end

end
