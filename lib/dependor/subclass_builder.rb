module Dependor
  class SubclassBuilder
    def self.get_dependency(name, injector, overwrites)
      return overwrites.fetch(name) { @injector[name] }
    end

    def self.subclass(klass, injector, overwrites = {})
      return klass unless klass.respond_to?(:class_takes)

      Class.new(klass) do
        klass.class_takes.each do |name|
          define_singleton_method name do
            unless instance_variable_get("@#{name}")
              instance_variable_set("@#{name}", overwrites.fetch(name) { injector[name] })
            end
            instance_variable_get("@#{name}")
          end
        end
      end
    end
  end
end
