Feature: Counter
  The counter should be incremented when the button is pressed.

  @smoke @regression
  Scenario: Counter increases when add button is pressed
    Given I expect the "counter" to be "0"
    When I tap the "increment" button 10 times
    Then I expect the "counter" to be "10"

  @smoke @regression
  Scenario: Counter decreases when the negate button is pressed
    When I tap the "increment" button 10 times
    Given I expect the "counter" to be "10"
    When I tap the "decrement" button 10 times
    Then I expect the "counter" to be "0"

  @regression
  Scenario: Counter should not go below 0
    When I tap the "decrement" button 10 times
    Then I expect the "counter" to be "0"
#
#  @regression
#  Scenario: Increment counter and then decrement
#    When I tap the "increment" button 10 times
#    Then I expect the "counter" to be "10"
#    When I tap the "decrement" button 2 times
#    Then I expect the "counter" to be "8"
#
#  @smoke @regression
#  Scenario: Decrement counter more than increment
#    When I tap the "increment" button 5 times
#    Then I expect the "counter" to be "5"
#    When I tap the "decrement" button 10 times
#    Then I expect the "counter" to be "0"