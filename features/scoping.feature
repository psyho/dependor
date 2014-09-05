Feature: Object Scoping

  By default, Dependor caches all of the objects it creates. In some cases you might want to change that behavior.

  Scenario: Singleton scope
    Given dependor is required with core extensions
    And a class is defined:
    """ruby
    class Example
      def initialize
        self.class.count += 1
      end

      def self.count
        @count ||= 0
      end

      def self.count=(value)
        @count = value
      end
    end
    """
    When I run:
    """ruby
    registry = Dependor.registry do
      autoinject(Object)
    end

    registry[:example]
    registry[:example]
    registry[:example]

    puts "Created #{Example.count} object"
    """
    Then the output should be:
    """
    Created 1 object
    """

  Scenario: Transient scope using class metadata
    Given dependor is required with core extensions
    And a class is defined:
    """ruby
    class Example
      extend Transient

      def initialize
        self.class.count += 1
      end

      def self.count
        @count ||= 0
      end

      def self.count=(value)
        @count = value
      end
    end
    """
    When I run:
    """ruby
    registry = Dependor.registry do
      autoinject(Object)
    end

    registry[:example]
    registry[:example]
    registry[:example]

    puts "Created #{Example.count} objects"
    """
    Then the output should be:
    """
    Created 3 objects
    """

  Scenario: Transient scope using registry configuration
    Given dependor is required with core extensions
    And a class is defined:
    """ruby
    class Example
      def initialize
        self.class.count += 1
      end

      def self.count
        @count ||= 0
      end

      def self.count=(value)
        @count = value
      end
    end
    """
    When I run:
    """ruby
    registry = Dependor.registry do
      autoinject(Object)
      example(transient: true)
    end

    registry[:example]
    registry[:example]
    registry[:example]

    puts "Created #{Example.count} objects"
    """
    Then the output should be:
    """
    Created 3 objects
    """
