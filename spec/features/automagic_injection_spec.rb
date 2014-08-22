require 'spec_helper'

module Sample
  module Legend
    class Camelot
      extend Takes(:king, :knights)
    end

    class Knight
      extend Takes(:name, :horse, :sword, :quest)
    end

    class King < Knight
      extend Takes(:crown)
    end

    class Horse
      extend Transient
    end

    class Quest
      extend Takes(:name)
    end

    class Sword
      extend Transient
    end

    class Crown
      extend Transient
    end

    class MagicalSword < Sword
      extend Takes(:name)
    end
  end
end

describe "Automagic Injection" do
  let(:registry) {
    Dependor.registry do
      autoinject(Sample::Legend)

      lancelot {
        new(:Knight,
            name: "Lancelot",
            quest: new(:Quest, name: "Lancelot & The Dragon"))
      }
      galahad {
        new(:Knight,
            name: "Galahad",
            quest: new(:Quest, name: "The Green Knight"))
      }
      arthur {
        new(:King,
            name: "Arthur",
            sword: excalibur,
            horse: new(:Horse),
            quest: new(:Quest, name: "The Holy Grail"))
      }
      excalibur { new(:MagicalSword, name: "Excalibur") }
      king { arthur }
      knights { [lancelot, galahad] }
    end
  }

  it "injects objects from given modules by name" do
    expect(registry[:camelot]).to be_an_instance_of(Sample::Legend::Camelot)
  end

  it "uses dependency overrides when constructing objects" do
    expect(registry[:arthur].name).to eq("Arthur")
  end

  it "allows referring to other objects by name" do
    expect(registry[:king]).to equal(registry[:arthur])
  end

  it "makes objects singletons by default" do
    first_camelot = registry[:camelot]
    second_camelot = registry[:camelot]

    expect(first_camelot).to equal(second_camelot)
  end

  it "returns a new instance every time for transient objects" do
    first_horse = registry[:horse]
    second_horse = registry[:horse]

    expect(first_horse).not_to equal(second_horse)
  end

  it "raises ObjectNotFound for unknown objects" do
    registry = Dependor.registry do
      foo { bar + 1 }
      bar { baz + 2 }
    end

    expect {
      registry[:foo]
    }.to raise_error(Dependor::ObjectNotFound)
  end

  it "does not allow dependency loops" do
    registry = Dependor.registry do
      foo { bar }
      bar { baz }
      baz { foo }
    end

    expect {
      registry[:foo]
    }.to raise_error(Dependor::DependencyLoopFound)
  end
end
