Feature: 3rd part account binding

  @javascript
  Scenario: unbind a github account
    Given I have already signed in as "cuterxy" with password "you_guess"
    And I have binded a github account
    And I click the unbind github account link
    Then I should unbind my github account