Feature: update bills

  As an Admin User
  I want to edit and publish a bill that was not claimed by any contributor
  So that the Contributor users can claim and pay them
  
  Scenario: update the unclaimed bill
    Given I am an admin
    And I have created bills:
    | issued_by | due_date   | total_amount | barcode | image    |
    | xxx       | 21/07/2020 | 300.0        | 000     | bill.png |
    When I select an unclaimed bill
    And I change issued_by detail of the bill to "yyy"
    And I change due_date detail of the bill to "22/07/2020"
    And I change total_amount detail of the bill to "100.00"
    And I change barcode detail of the bill to "001"
    Then I should view bill information:
    | issued_by | due_date    | total_amount | barcode  | 
    | yyy       | 22/07/2020  | 100.0        | 001      |
    
  Scenario: do not update the unclaimed bill with invalid date
    Given I am an admin
    And I have created bills:
    | issued_by | due_date   | total_amount | barcode | image    |
    | xxx       | 21/07/2020 | 300.0        | 000     | bill.png |
    When I select an unclaimed bill
    And I change due_date detail of the bill to "52/07/2020"
    Then I should see the error message "Complete com uma data válida"
 
  Scenario: do not update the unclaimed bill with invalid total amount
    Given I am an admin
    And I have created bills:
    | issued_by | due_date   | total_amount | barcode | image    |
    | xxx       | 21/07/2020 | 300.0        | 000     | bill.png |
    When I select an unclaimed bill
    And I change total_amount detail of the bill to "-100.00"
    Then I should see the error message "Valor total deve ser maior que zero"
    
  Scenario: do not update the unclaimed bill with invalid barcode
    Given I am an admin
    And I have created bills:
    | issued_by | due_date   | total_amount | barcode | image    |
    | xxx       | 21/07/2020 | 300.0        | 000     | bill.png |
    When I select an unclaimed bill
    And I change barcode detail of the bill to "aaa"
    Then I should see the error message "Código de barras deve ser um valor numérico"