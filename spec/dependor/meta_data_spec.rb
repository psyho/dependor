require File.expand_path('../../spec_helper.rb', __FILE__)

describe Dependor::MetaData do

  class NoMetaDataSample
  end

  describe "for class that has no metadata specified" do
    it "should have no dependencies" do
      metadata = Dependor::MetaData.for(NoMetaDataSample)

      metadata.dependencies.should == Set.new()
    end
  end

  class SomeDependenciesSample
    include Dependor::Injectable

    depends_on :foo, :bar
  end

  describe "for a typical class with some dependencies" do
    it "should contain all of the dependencies" do
      metadata = Dependor::MetaData.for(SomeDependenciesSample)

      metadata.dependencies.should == Set.new([:foo, :bar])
    end
  end

  class InheritingFromClassWithDependenciesSample < SomeDependenciesSample
    depends_on :baz
  end

  describe "for a class inherinting from another class with dependencies" do
    it "should contain all of the inherited and newly declared dependencies" do
      metadata = Dependor::MetaData.for(InheritingFromClassWithDependenciesSample)

      metadata.dependencies.should == Set.new([:foo, :bar, :baz])
    end
  end

  class InheritingFromClassWithNoDependenciesSample < NoMetaDataSample
    include Dependor::Injectable

    depends_on :bar
  end

  describe "for a class inheriting from another class without dependencies" do
    it "should contain the declared dependencies" do
      metadata = Dependor::MetaData.for(InheritingFromClassWithNoDependenciesSample)

      metadata.dependencies.should == Set.new([:bar])
    end
  end

  describe "for an instance of a class with no dependencies declared" do
    it "should return empty metadata" do
      metadata = Dependor::MetaData.for(NoMetaDataSample.new)

      metadata.dependencies.should == Set.new
    end
  end

  describe "for an instance of a class with some dependencies declared" do
    it "should return the same metadata as for the class" do
      metadata = Dependor::MetaData.for(SomeDependenciesSample.new)

      metadata.dependencies.should == Set.new([:foo, :bar])
    end
  end

end
