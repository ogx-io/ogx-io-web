Feature: user favorites

  Scenario: user favor a board
    Given a board with name "Test Board"
    And I have already signed in as "test_user" with password "password"
    When I click the link with id "favor-board" on the page of the board
    Then I would favor the board

  Scenario: user disfavor a board
    Given a board with name "Test Board"
    And I have already signed in as "test_user" with password "password"
    And I have favored the board
    When I click the link with id "disfavor-board" on the page of the board
    Then I would disfavor the board
