module Dependor
  module TakesExt
    module_function
    def Takes(*dependency_names)
      Module.new do
        define_singleton_method :extended do |klass|
          klass.send(:include, Dependor::Injectable)
          klass.takes(*dependency_names)
        end
      end
    end
  end
end
