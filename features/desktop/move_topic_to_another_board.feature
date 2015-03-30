Feature: move a topic to another board
  Scenario: move a topic to another board by moderator
    Given I have already signed in as "cuterxy" with password "you_guess"
    And there is a topic with 10 replies
    And there are some comments in some of the replies of the topic
    And I am the moderator of the board of the topic
    And I click the "move" link of the topic
    Then I should see the form for moving the topic
    And submit the new board id that the topic is changing to
    Then the topic and its posts and comments should be changed to the new board
