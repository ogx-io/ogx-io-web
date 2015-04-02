Feature: providing a pretty path for boards and categories, for example, '/people/codingirl' for the board of '程序媛'
  Scenario: visit a pretty path to a board
    Given there is a category with name "One" and path "one"
    And there is a child board with name "Two" and path "two"
    And visit the path "/one/two"
    Then you should see the board "Two"

  Scenario: visit a pretty path to a category
    Given there is a category with name "One" and path "one"
    And there is a child category with name "Two" and path "two"
    And visit the path "/one/two"
    Then you should see the category "Two"