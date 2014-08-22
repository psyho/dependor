require 'spec_helper'

describe Dependor::LookupChain do
  let(:chain) { Dependor::LookupChain.new }

  it "pretty prints the chain" do
    chain.start(:foo)
    chain.start(:bar)
    chain.start(:baz)

    expect(chain.to_s).to eq("foo -> bar -> baz")
  end

  it "removes the last item from the chain when a lookup finishes" do
    chain.start(:foo)
    chain.start(:bar)
    chain.start(:baz)
    chain.finish

    expect(chain.to_s).to eq("foo -> bar")
  end

  it "detects loops in the chain" do
    chain.start(:foo)
    chain.start(:bar)

    expect {
      chain.start(:foo)
    }.to raise_error(Dependor::DependencyLoopFound, "Dependency loop found: foo -> bar")
  end

  it "clears itself once a lookup chain is detected" do
    chain.start(:foo)
    chain.start(:bar)
    expect{ chain.start(:foo) }.to raise_error

    expect(chain.to_s).to eq("")
  end
end
