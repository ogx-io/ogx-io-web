Feature: Record and show the click count of a topic
  Scenario: show a topic
    Given there is a new topic
    When visit the topic
    Then the click count of the topic should be 1
    And visit the topic
    Then the click count of the topic should be 2
    And visit the topic on the page 2
    Then the click count of the topic should be 2
