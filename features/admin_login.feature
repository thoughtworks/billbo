Feature: login with google account

  As an admin of billbo
  I want to login with my google account
  So that I can upload news bills to the system

  Scenario: Access the bill creation page
    Given I am an admin
    Then I should be able to access the bill creation page

    Given I am not an admin
    Then I should not be able to access the bill creation page
