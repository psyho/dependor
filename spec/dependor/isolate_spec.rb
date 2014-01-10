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
    expect(context.subject.foo).to eq("the foo stub")
    expect(context.subject.bar).to eq("the bar stub")
  end

  it "allows overriding dependencies with variables" do
    expect(context.override.bar).to eq("bar was overriden")
    expect(context.override.foo).to eq("the foo stub")
  end

  it "allows overriding dependencies with parameters" do
    expect(context.parameters.bar).to eq("the parameter")
    expect(context.parameters.foo).to eq("the foo stub")
  end
end
