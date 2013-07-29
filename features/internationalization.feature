Feature: Internationalization

  As a user of billbo
  I want to have support to multiple languages
  So that I can communicate in the language of my preference

  Scenario: Portuguese as default language
    When I open the home page
    Then the website should be in portuguese

  Scenario: Change website language between languages
    Given the website is in portuguese
    When I change the website language to english
    Then the website should be in english
    When I change the website language to portuguese
    Then the website should be in portuguese

  Scenario: Error loads the default language file
    Given the website receives a invalid internationalization code
    When I open the home page
    Then the website should be in portuguese
