require 'spec_helper'

module Dependor
  module Injectable
    module Constructor
      def initialize(dependencies = {})
        takes = self.class.takes

        missing = takes - dependencies.keys
        extra = dependencies.keys - takes
        raise ArgumentError, "Missing arguments: #{missing.join(', ')}" if missing.any?
        raise ArgumentError, "Unknown arguments passed: #{extra.join(', ')}" if extra.any?

        takes.each do |name|
          instance_variable_set("@#{name}", dependencies.fetch(name))
        end
      end
    end

    module Takes
      def takes(*dependency_names)
        @takes ||= []

        if dependency_names.empty?
          parent_takes = superclass.takes if superclass.respond_to?(:takes)
          parent_takes ||= []
          return @takes + parent_takes
        else
          @takes += dependency_names
          attr_reader(*dependency_names)
        end
      end
    end

    module Transient
      def self.transient?(klass)
        self > klass.singleton_class
      end
    end
  end

  ObjectDefinition = Struct.new(:name, :opts, :builder) do
    def self.default_for(klass)
      opts = {transient: Transient.transient?(klass)}
      new(klass.name.to_sym, opts, proc{ new(klass) })
    end

    def singleton?
      !opts[:transient]
    end
  end

  class RegistryConfiguration < BasicObject
    def self.configure(&block)
      configuration = new
      configuration.instance_eval(&block)
      configuration
    end

    attr_reader :__autoinject_modules__, :__definitions__

    def initialize
      @__autoinject_modules__ = []
      @__definitions__ = {}
    end

    def autoinject(mod)
      @__autoinject_modules__ << mod
    end

    def method_missing(name, opts = {}, &block)
      @__definitions__[name] = ObjectDefinition.new(name, opts, block)
    end
  end

  class ClassLookup
    def initialize(modules)
      @modules = modules
    end

    def lookup(class_name)
      class_name = camelize(class_name)
      modules.lazy.map {|m| try_get_class(m, class_name) }.detect{ |klass| klass }
    end

    private

    attr_reader :modules

    def try_get_class(mod, class_name)
      mod.const_get(class_name)
    rescue NameError
    end

    def camelize(name)
      name.to_s.gsub(/^\w/, &:upcase).gsub(/_\w/, &:upcase).gsub('_', '')
    end
  end

  class DependencyLookup
    def self.for_class(klass)
      return [] unless klass.respond_to?(:takes)
      klass.takes
    end
  end

  class Instantiator < BasicObject
    def initialize(class_lookup, injector)
      @class_lookup = class_lookup
      @injector = injector
    end

    def instantiate(definition)
      instance_exec(&definition.builder)
    end

    def new(klass_name, overwrites = {})
      klass = @class_lookup.lookup(klass_name)
      dependencies = DependencyLookup.for_class(klass)
      return klass.new if dependencies.empty?
      args = {}
      dependencies.each do |name|
        args[name] = overwrites.fetch(name) { @injector[name] }
      end
      klass.new(args)
    end

    def method_missing(name, *args, &block)
      super if args.any?
      @injector[name]
    end
  end

  class ObjectNotFound < StandardError
    def initialize(object_name)
      super("Object #{object_name} not found!")
    end
  end

  class Registry
    def self.build(&block)
      registry = new
      registry.configure(&block)
      registry
    end

    def initialize
      @autoinject_modules = []
      @definitions = {}
      @objects = {}
    end

    def configure(&block)
      configuration = RegistryConfiguration.configure(&block)
      @autoinject_modules += configuration.__autoinject_modules__
      @definitions = definitions.merge(configuration.__definitions__)
    end

    def [](name)
      return @objects[name] if @objects.key?(name)
      definition = fetch_definition(name)
      object = instantiator.instantiate(definition)
      @objects[name] = object if definition.singleton?
      object
    end

    private

    def fetch_definition(name)
      return definitions[name] if definitions.key?(name)
      klass = class_lookup.lookup(name)
      return ObjectDefinition.default_for(klass) if klass
      raise ObjectNotFound.new(name)
    end

    def class_lookup
      ClassLookup.new(autoinject_modules)
    end

    def instantiator
      Instantiator.new(class_lookup, self)
    end

    attr_reader :autoinject_modules, :definitions
  end

  def self.registry(&block)
    Registry.build(&block)
  end
end

module Dependor
  module CoreExt
    def Takes(*dependency_names)
      Module.new do
        define_singleton_method :extended do |klass|
          klass.send(:include, Dependor::Injectable::Constructor)
          klass.extend Dependor::Injectable::Takes
          klass.takes(*dependency_names)
        end
      end
    end
  end
end


Object.extend Dependor::CoreExt
Transient = Dependor::Injectable::Transient

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
