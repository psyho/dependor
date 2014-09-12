module Dependor
  module ClassTakesExt
    module_function
    def ClassTakes(*names)
      Module.new do
        define_singleton_method :extended do |klass|
          klass.send(:extend, Dependor::InjectableClass)
          klass.add_dependencies(*names)
        end
      end
    end
  end
end
