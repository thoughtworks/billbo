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

  Scenario: upload a receipt without the contributor email
    Given I open the home page
    And I have 2 bills
    And I select a bill
    When I upload a receipt without the contributor email
    Then I should see the error message "E-mail é um campo obrigatório"
