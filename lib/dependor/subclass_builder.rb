module Dependor
  class SubclassBuilder
    def self.subclass(klass, injector)
      return klass unless klass.respond_to?(:class_takes)

      Class.new(klass) do
        klass.class_takes.each do |dependency|
          define_singleton_method dependency do
            injector[dependency]
          end
        end
      end
    end
  end
end
