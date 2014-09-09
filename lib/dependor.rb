require "dependor/version"

require "dependor/injectable"
require "dependor/transient"
require "dependor/takes_ext"

require "dependor/object_definition"
require "dependor/registry_configuration"
require "dependor/class_lookup"
require "dependor/dependency_lookup"
require "dependor/instantiator"
require "dependor/object_not_found"
require "dependor/dependency_loop_found"
require "dependor/registry"
require "dependor/lookup_chain"

require "dependor/injectable_class"
require "dependor/class_takes_ext"
require "dependor/subclass_builder"

module Dependor
  def self.registry(&block)
    Registry.build(&block)
  end

  def self.takes(*dependency_names)
    TakesExt.Takes(*dependency_names)
  end

  def self.class_takes(*dependency_names)
    ClassTakesExt.ClassTakes(*dependency_names)
  end
end
