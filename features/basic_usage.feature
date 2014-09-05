Feature: Basic Usage

  In it's simplest form, Dependor is used to automatically build complex object graphs.
  It uses convention-over-configuration to find classes matching dependency names defined using Dependor::Takes.

  Background:
    Given a class is defined:
    """ruby
    class Horse
      def ride
        puts "Clip Clop Clip Clop"
      end
    end
    """
    And a class is defined:
    """ruby
    class Quest
      def complete
        puts "Behold the Holy Grail!"
      end
    end
    """

  Scenario: with dependor/core_ext required
    Given dependor is required using:
    """ruby
    require 'dependor'
    require 'dependor/core_ext'
    """
    And a class is defined:
    """ruby
    class Knight
      extend Takes(:quest, :horse)

      def embark_on_a_quest
        puts "Goodbye, my love!"
        horse.ride
        quest.complete
      end
    end
    """
    When I run:
    """ruby
    registry = Dependor.registry do
      autoinject(Object)
    end

    knight = registry[:knight]

    knight.embark_on_a_quest
    """
    Then the output should be:
    """
    Goodbye, my love!
    Clip Clop Clip Clop
    Behold the Holy Grail!
    """

  Scenario: without dependor/core_ext
    Given dependor is required using:
    """ruby
    require 'dependor'
    """
    And a class is defined:
    """ruby
    class Knight
      extend Dependor.takes(:quest, :horse)

      def embark_on_a_quest
        puts "Goodbye, my love!"
        horse.ride
        quest.complete
      end
    end
    """
    When I run:
    """ruby
    registry = Dependor.registry do
      autoinject(Object)
    end

    knight = registry[:knight]

    knight.embark_on_a_quest
    """
    Then the output should be:
    """
    Goodbye, my love!
    Clip Clop Clip Clop
    Behold the Holy Grail!
    """
