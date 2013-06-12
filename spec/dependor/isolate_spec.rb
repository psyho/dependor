require 'spec_helper'

describe Dependor::Isolate do
  class ExampleSubject
    takes :foo, :bar
  end

  class ExampleContext
    include Dependor::Isolate

    def subject
      isolate{ExampleSubject}
    end

    def override
      bar = "bar was overriden"
      isolate{ExampleSubject}
    end

    def parameters
      isolate(ExampleSubject, bar: "the parameter")
    end

    def foo
      "the foo stub"
    end

    def bar
      "the bar stub"
    end
  end

  let(:context) { ExampleContext.new }

  it "injects the subject's dependencies using methods on context" do
    context.subject.foo.should == "the foo stub"
    context.subject.bar.should == "the bar stub"
  end

  it "allows overriding dependencies with variables" do
    context.override.bar.should == "bar was overriden"
    context.override.foo.should == "the foo stub"
  end

  it "allows overriding dependencies with parameters" do
    context.parameters.bar.should == "the parameter"
    context.parameters.foo.should == "the foo stub"
  end
end
