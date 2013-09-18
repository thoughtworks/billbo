Feature: store bills

  As a user of billbo
  I want to store bills
  So that I can share them with other users

  Scenario: create a bill
    Given I am an admin
    When I create a bill
    Then it should show success message

  Scenario: check out bill information
    Given I am an admin
    And I have created bills:
    | issued_by | due_date   | total_amount | barcode | image    |
    | xxx       | 2020/07/21 | 300.0        | 000     | bill.png |
    When I open the home page
    Then I should view bills information:
    | issued_by | total_amount | image    |
    | xxx       | 300.0        | bill.png |

  Scenario: create an empty bill
    When I try to create an empty bill
    Then it should fail

  Scenario: list all bills
    Given I have 3 bills
    When I open the home page
    Then it should list 3 bills

  Scenario: do not show closed bills
    Given I have 3 bills
    And I set the status of 1 of them as paid
    When I open the home page
    Then it should list 2 bills

  Scenario: create a bill with duplicated barcode
    Given I am an admin
    And there is a bill with barcode "01234"
    When I try to create a new bill with barcode "01234"
    Then I should see the error message "Código de barras já está em uso"
