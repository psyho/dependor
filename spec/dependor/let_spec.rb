require 'spec_helper'

describe Dependor::Let do
  class SampleClassUsingLet
    extend Dependor::Let

    let(:foo) { "foo foo" }
  end

  it 'shortens method declaration' do
    expect(SampleClassUsingLet.new.foo).to eq("foo foo")
  end
end
