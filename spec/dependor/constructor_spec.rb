require_relative '../spec_helper'

describe 'Dependor::Constructor' do
  class SampleClassUsingConstructor
    include Dependor::Constructor(:foo, :bar, :baz)

    def as_instance_variables
      {foo: @foo, bar: @bar, baz: @baz}
    end
  end

  it 'defines a constructor with given parameters' do
    sample = SampleClassUsingConstructor.new('aaa', 'bbb', 'ccc')
    sample.as_instance_variables.should == {foo: 'aaa', bar: 'bbb', baz: 'ccc'}
  end
end
