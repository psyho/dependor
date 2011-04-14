require File.expand_path('../../spec_helper.rb', __FILE__)

describe Dependor::DependencyToClassNameConverter do

  before(:each) do
    @converter = Dependor::DependencyToClassNameConverter.new
  end

  it "should convert simple names to camel case" do
    @converter.convert(:foo).should == "Foo"
  end

  it "should convert multi part underscore_names to CamelCase" do
    @converter.convert(:some_component).should == "SomeComponent"
  end

  it "should convert - to :: in names" do
    @converter.convert("some_module-some_class").should == "SomeModule::SomeClass"
  end

  it "should leave camelcase names unchanged" do
    @converter.convert("SomeClass").should == "SomeClass"
  end

  it "should leave camelcase names with :: in them unchanged" do
    @converter.convert("SomeModule::SomeClass").should == "SomeModule::SomeClass"
  end

end
