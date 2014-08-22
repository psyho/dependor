require 'spec_helper'
require 'dependor/core_ext'

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
  let(:legend) {
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

  let(:injector) { legend }

  it "injects objects from given modules by name" do
    expect(injector[:camelot]).to be_an_instance_of(Sample::Legend::Camelot)
  end

  it "makes objects singletons by default" do
    first_camelot = injector[:camelot]
    second_camelot = injector[:camelot]

    expect(first_camelot).to equal(second_camelot)
  end

  it "returns a new instance every time for transient objects" do
    first_horse = injector[:horse]
    second_horse = injector[:horse]

    expect(first_horse).not_to equal(second_horse)
  end
end
