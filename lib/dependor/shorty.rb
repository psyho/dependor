module Dependor
  module Shorty
    def takes(*names)
      attr_reader *names

      class_eval <<-RUBY

      def initialize(#{names.join(', ')})
        #{names.map{ |name| "@#{name} = #{name}" }.join("\n") }
      end

      RUBY
    end
  end
end

class Object
  extend Dependor::Shorty
end
