module Dependor
  module Shorty
    def takes(*names)
      attr_reader *names
      include Dependor::Constructor(*names)
      extend Dependor::Let
    end
  end
end

class Object
  extend Dependor::Shorty
end
