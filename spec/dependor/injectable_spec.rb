require 'spec_helper'

describe Dependor::Injectable do
  class SampleInjector
    def foo
      "foo"
    end
  end

  class SampleInjectable
    extend Dependor::Injectable
    inject_from(SampleInjector)

    inject :foo

    def hello_foo
      "hello #{foo}"
    end
  end

  class SampleInjectableWithoutAnInjector
    extend Dependor::Injectable

    inject :foo

    def hello_foo
      "hello #{foo}"
    end
  end

  it "requires the class to provide injector method" do
    injectable = SampleInjectableWithoutAnInjector.new

    expect do
      injectable.hello_foo
    end.to raise_exception
  end

  it "uses the provided injector" do
    injectable = SampleInjectable.new

    expect(injectable.hello_foo).to eq('hello foo')
  end

  describe "typical Rails usage" do
    class ApplicationController
      extend Dependor::Injectable
      inject_from SampleInjector
    end

    class PostsController < ApplicationController
      inject :foo

      def get
        "render #{foo}"
      end
    end

    it "should return foo value in child controller" do
      expect(PostsController.new.get).to eq("render foo")
    end
  end
end
