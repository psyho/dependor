require_relative '../spec_helper'

require 'dependor/shorty'

describe Dependor::Shorty do
  class SampleClassThatUsesTakes
    takes :foo, :bar, :baz

    def as_instance_variables
      {foo: @foo, bar: @bar, baz: @baz}
    end

    def as_attributes
      {foo: foo, bar: bar, baz: baz}
    end
  end

  subject{ SampleClassThatUsesTakes.new('foo value', 'bar value', 'baz value') }

  it 'defines a constructor with given names' do
    subject.as_instance_variables.should == { foo: 'foo value',
      bar: 'bar value',
      baz: 'baz value'
    }
  end

  it 'defines attr_reader for the given names' do
    subject.as_attributes.should == { foo: 'foo value',
      bar: 'bar value',
      baz: 'baz value'
    }
  end
end
