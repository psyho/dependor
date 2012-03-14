require_relative '../spec_helper'

require 'dependor/shorty'

describe Dependor::AutomagicallyInjectsDependencies do
  class SampleClassWithNoDependencies
  end

  class SampleClassWithDependency
    takes :sample_class_with_no_dependencies
  end

  class SampleClassWithManualDependency
    takes :manual_dep
  end

  module SomeModule
    class SampleClassWithinSomeModule
    end
  end

  class SampleInjector
    include Dependor::AutomagicallyInjectsDependencies
    look_in_modules SomeModule

    def manual_dep
      "manual dep"
    end
  end

  let(:injector) { SampleInjector.new }
  let(:object_class) { constantize(camelize(object_name)) }

  shared_examples_for 'dependency injector' do
    it 'responds to the object name' do
      injector.should respond_to(object_name)
    end

    it 'creates the object' do
      injector.send(object_name).should be_an_instance_of(object_class)
    end
  end

  context 'no dependencies' do
    let(:object_name) { :sample_class_with_no_dependencies }

    it_behaves_like 'dependency injector'
  end

  context 'dependencies on other objects' do
    let(:object_name) { :sample_class_with_dependency }

    it_behaves_like 'dependency injector'
  end

  context 'dependencies on objects returned by methods on the injector' do
    let(:object_name) { :sample_class_with_manual_dependency }

    it_behaves_like 'dependency injector'
  end

  context 'dependencies from another module' do
    let(:object_name) { :sample_class_within_some_module }
    let(:object_class) { SomeModule::SampleClassWithinSomeModule }

    it_behaves_like 'dependency injector'
  end

  it "raises an error if the object is not found" do
    proc{ injector.unknown_object }.should raise_exception(Dependor::AutoInject::UnknownObject)
  end

  it 'responds to regular methods on injector' do
    injector.should respond_to(:manual_dep)
  end

  def camelize(string)
    Dependor::AutoInject::PrivateMethods.camelize(string)
  end

  def constantize(string)
    Object.const_get(string)
  end
end
