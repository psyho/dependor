require 'spec_helper'

describe Dependor::Isolate do
  class ExampleSubject
    takes :foo, :bar
  end

  class ExampleContext
    include Dependor::Isolate

    def subject
      isolate(ExampleSubject)
    end

    def override
      isolate(ExampleSubject, bar: "bar was overriden")
    end

    def foo
      "the foo stub"
    end

    def bar
      "the bar stub"
    end
  end

  it "injects the subject's dependencies using methods on context" do
    context = ExampleContext.new

    context.subject.foo.should == "the foo stub"
    context.subject.bar.should == "the bar stub"
  end

  it "allows overriding dependencies" do
    context = ExampleContext.new

    context.override.bar.should == "bar was overriden"
    context.override.foo.should == "the foo stub"
  end
end
