Feature: store bills

  As a user of billbo
  I want to store bills
  So that I can share them with other users

  Scenario: create an empty bill
    When I create an empty bill
    Then it should succeed

  Scenario: list all bills
    Given I have 3 bills
    When I open the home page
    Then it should list 3 bills

  Scenario: do not show closed bills
    Given I have 3 bills
    And set the status of 1 of them as closed
    When I open the home page
    Then it should list 2 bills
