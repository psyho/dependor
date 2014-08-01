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

        puts "Instantiating #{self.class}"
      end
    end

    def takes(*dependency_names)
      @takes ||= []
      parent_takes = superclass.takes if superclass.respond_to?(:takes)
      parent_takes ||= []
      return @takes + parent_takes if dependency_names.empty?
      @takes += dependency_names
      attr_reader(*dependency_names)
      include Constructor
    end
  end

  ObjectName = Struct.new(:name) do
    def symbolic_name
      @symbolic_name ||= name.to_sym
    end

    def class_name
      @class_name ||= name.to_s.gsub(/^\w/, &:upcase).gsub(/_\w/, &:upcase).gsub('_', '')
    end
  end

  class RegistryConfiguration < BasicObject
    def initialize(registry)
      @registry = registry
    end

    def method_missing(name, options = {}, &block)
      @registry.define(name, options, &block)
    end
  end

  class Instantiator < BasicObject
    def initialize(injector, parent_module)
      @injector = injector
      @parent_module = parent_module
    end

    def instantiate(block)
      instance_eval(&block)
    end

    def new(class_name, dependency_overrides = {})
      dependencies = dependency_overrides.dup
      klass = __lookup_class__(class_name)

      klass.takes.each do |name|
        next if dependencies.key?(name)
        dependencies[name] = @injector[name]
      end

      dependencies.empty? ? klass.new : klass.new(dependencies)
    end

    def method_missing(name, *args, &block)
      @injector[name]
    end

    def __lookup_class__(name)
      return name if name.is_a?(::Class)
      object_name = ::Dependor::ObjectName.new(name)
      @parent_module.const_get(object_name.class_name)
    end
  end

  ObjectDefinition = Struct.new(:block, :parent_module, :prototype) do
    def prototype?
      prototype
    end

    def call(injector)
      Instantiator.new(injector, parent_module).instantiate(block)
    end
  end

  class Registry
    def initialize(parent_module)
      @parent_module = parent_module
      @custom_definitions = {}
    end

    def configure(&block)
      return unless block_given?
      configuration = RegistryConfiguration.new(self)
      configuration.instance_eval(&block)
    end

    def define(name, options = {}, &block)
      name = ObjectName.new(name)
      unless block
        klass = class_for_name(name)
        block = proc{ new(klass) }
      end
      custom_definitions[name] = ObjectDefinition.new(block, parent_module, options[:prototype])
    end

    def key?(name)
      custom_definitions.key?(name) || !!class_for_name(name)
    end

    def fetch(name)
      return custom_definitions.fetch(name) if custom_definitions.key?(name)
      klass = class_for_name(name)
      block = proc{ new(klass) }
      ObjectDefinition.new(block, parent_module)
    end

    private

    def block_for_name(name)
    end

    def class_for_name(name)
      parent_module.const_get(name.class_name)
    rescue NameError
      nil
    end

    attr_reader :parent_module, :custom_definitions
  end

  class ObjectNotFound < StandardError
    def initialize(name, current_lookup)
      path = current_lookup.map(&:symbolic_name).join(' -> ')
      super("Could not find object: #{name.symbolic_name} (#{path}) in any of the registries!")
    end
  end

  class Injector
    def initialize(*registries)
      @registries = registries
      @objects = {}
      @current_lookup = []
    end

    def [](name)
      object_name = ObjectName.new(name)
      key = object_name.symbolic_name
      return objects[key] if objects.key?(key)

      current_lookup << object_name
      object_definition = find_in_registries(object_name)
      object = object_definition.call(self)
      current_lookup.pop
      objects[key] = object unless object_definition.prototype?
      object
    end

    private

    def find_in_registries(name)
      registry = registries.detect{|r| r.key?(name)}
      raise ObjectNotFound.new(name, current_lookup) unless registry
      registry.fetch(name)
    end

    attr_reader :registries, :objects, :current_lookup
  end

  def self.registry(parent_module, &block)
    registry = Registry.new(parent_module)
    registry.configure(&block)
    registry
  end

  def self.injector(*registries)
    Injector.new(*registries)
  end
end

Object.extend Dependor::Injectable

module Sample
  module Legend
    class Camelot
      takes :king, :knights
    end

    class Knight
      takes :name, :horse, :sword, :quest
    end

    class King < Knight
      takes :crown
    end

    class Horse
      include Dependor::Injectable::Constructor
    end

    class Quest
      takes :name
    end

    class Sword
      include Dependor::Injectable::Constructor
    end

    class Crown
      include Dependor::Injectable::Constructor
    end

    class MagicalSword < Sword
      takes :name
    end
  end
end

describe "Automagic Injection" do
  legend = Dependor.registry(Sample::Legend) do
    sword(prototype: true)
    horse(prototype: true)

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
    #knight_provider { |name, quest|
      #new(:Knight,
          #name: name,
          #quest: new(:Quest, name: quest))
    #}
    excalibur { new(:MagicalSword, name: "Excalibur") }
    king { arthur }
    knights { [lancelot, galahad] }
  end

  let(:injector) { Dependor.injector(legend) }

  it "injects objects from given modules by name" do
    injector[:camelot]
    expect(injector[:camelot]).to be_an_instance_of(Sample::Legend::Camelot)
  end
end
