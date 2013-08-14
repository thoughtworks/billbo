Feature: upload receipt

  As a user of billbo
  I want to upload a receipt
  So that admin can close the bill

  Scenario: upload a receipt for selected bill
    Given I open the home page
    And I have 2 bills
    And I select a bill
    When I upload a receipt 
    Then it should show success message
