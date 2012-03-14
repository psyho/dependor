module Dependor
  def self.Constructor(*names)
    eval <<-RUBY

    Module.new do
      def initialize(#{names.join(', ')})
        #{names.map{ |name| "@#{name} = #{name}" }.join("\n") }
      end
    end

    RUBY
  end
end
