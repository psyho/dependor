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

    expect(resolver.for_name(:something)).to be_nil
  end

  it "uses global scope with no search_modules" do
    resolver = Dependor::ClassNameResolver.new([])

    expect(resolver.for_name(:foo_bar_baz)).to eq(FooBarBaz)
  end

  it "searches modules in order specified" do
    resolver = Dependor::ClassNameResolver.new([Foo, Bar])

    expect(resolver.for_name(:foo_bar_baz)).to eq(Foo::FooBarBaz)
  end

  it "searches in order specified, with the global scope last" do
    resolver = Dependor::ClassNameResolver.new([Foo, Bar])

    expect(resolver.for_name(:foo_bar_baz_2)).to eq(FooBarBaz2)
  end

  it "doesnt have Object in search modules after calling for_name" do
    resolver = Dependor::ClassNameResolver.new([])

    resolver.for_name(:something)
    expect(resolver.search_modules).not_to include(Object)
  end
end
