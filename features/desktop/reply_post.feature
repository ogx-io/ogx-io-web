@javascript
Feature: reply post
  Scenario: fast reply in the post list
    Given there is a topic with 15 replies
    And I have already signed in as "cuterxy" with password "you_guess"
    And I click the reply link of the post of the 7th floor
    Then the reply form should appear
    And I input "test content" into the textarea
    And I click the submit button of the reply form
    Then the new reply post should appear below the replied post

