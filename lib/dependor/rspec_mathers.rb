module Dependor
  module RSpecMatchers

    def have_received
      return MethodCallMatcher.new
    end

    class MethodCallMatcher

      def matches?(subject)
        @subject = subject

        unless expectation_specified?
          raise "have_received matcher must be called with some method name, like: have_received.method_name(args)"
        end

        return subject.__method_calls__.include?([@name, @args])
      end

      def failure_message_for_should
        "#{@subject} should have received #{@name}(#{@args.map(&:inspect).join(', ')}), but it didn't."
      end

      def failure_message_for_should_not
        "#{@subject} should not have received #{@name}(#{@args.map(&:inspect).join(', ')}), but it did."
      end

      protected

      def expectation_specified?
        !!(@name && @args)
      end

      def method_missing(name, *args, &block)
        @name = name
        @args = args

        self
      end

    end
  end
end
