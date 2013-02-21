Feature: store bills

    As a user of billbo
    I want to store bills
    So that I can share them with other users

    Scenario: create an empty bill
        When I create an empty bill
        Then it should succeed
