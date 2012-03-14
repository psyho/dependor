module Dependor
  module Injectable
    def inject_from(klass)
      define_method :injector do
        @injector ||= klass.new
      end
    end

    def inject(*names)
      names.each do |name|
        define_method name do
          injector.send(name)
        end
      end
    end
  end
end
