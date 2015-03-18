@javascript
Feature: like post
  Scenario: like a post
    Given there is a post
    And I have already signed in as "test_user" with password "password"
    And I visit the post
    And I click the link with id "like" for the post and wait for "dislike"
    Then the like count of the post should be 1
    And I click the link with id "dislike" for the post and wait for "like"
    Then the like count of the post should be 0

  Scenario: many people like one post
    Given there is a post
    And I have already signed in as "test_user" with password "password"
    And I visit the post
    And I click the link with id "like" for the post and wait for "dislike"
    Then the like count of the post should be 1
    And I click the "Sign Out" button in the header
    And I have already signed in as "test_user_2" with password "password2"
    And I visit the post
    And I click the link with id "like" for the post and wait for "dislike"
    Then the like count of the post should be 2
