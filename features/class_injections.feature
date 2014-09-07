@todo
Feature: Class Injections

  Dependor allows to inject classes and class properties

  @ignore
  Scenario: Injecting class properties
    Given dependor is required with core extensions
    And a class is defined:
    """ruby
    class Knight
      extend Dependor.takes(:king)

      def embark_on_a_quest
        puts "For the King!"
        king.greet_knight
      end
    end
    """
    And a class is defined:
    """ruby
    class King
      extend Dependor.class_takes(:monarchy_name)

      def self.greet_knight
        puts "Welcome to #{monarchy_name}'s army, fellow Sword Master."
      end
    end
    """
    When I run:
    """ruby
    registry = Dependor.registry do
      autoinject(Object)
      king(as: :class)
      monarchy_name { "FarFarAway" }
    end

    knight = registry[:knight]

    knight.embark_on_a_quest
    """
    Then the output should be:
    """
    "For the King!"
    "Welcome to FarFarAway's army, fellow Sword Master."
    """

