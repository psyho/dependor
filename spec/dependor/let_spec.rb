require 'spec_helper'

describe Dependor::Let do
  class SampleClassUsingLet
    extend Dependor::Let

    let(:foo) { "foo foo" }
  end

  it 'shortens method declaration' do
    SampleClassUsingLet.new.foo.should == "foo foo"
  end
end
