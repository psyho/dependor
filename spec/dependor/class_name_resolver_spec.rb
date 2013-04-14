require 'spec_helper'

describe Dependor::ClassNameResolver do
  class FooBarBaz
  end

  class FooBarBaz2
  end

  module Foo
    class FooBarBaz
    end
  end

  module Bar
    class FooBarBaz
    end
  end

  it "returns nil when the class could not be found" do
    resolver = Dependor::ClassNameResolver.new([])

    resolver.for_name(:something).should be_nil
  end

  it "uses global scope with no search_modules" do
    resolver = Dependor::ClassNameResolver.new([])

    resolver.for_name(:foo_bar_baz).should == FooBarBaz
  end

  it "searches modules in order specified" do
    resolver = Dependor::ClassNameResolver.new([Foo, Bar])

    resolver.for_name(:foo_bar_baz).should == Foo::FooBarBaz
  end

  it "searches in order specified, with the global scope last" do
    resolver = Dependor::ClassNameResolver.new([Foo, Bar])

    resolver.for_name(:foo_bar_baz_2).should == FooBarBaz2
  end
end
