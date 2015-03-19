Feature: visit a post
  Scenario: user not sign in
    Given there is a post
    When I visit the post
    Then I should see the post

  Scenario: user sign in
    Given there is a post
    And I have already signed in as "cuterxy" with password "you_guess"
    When I visit the post
    Then I should see the post

  Scenario: you can not see a post deleted by me, but I can
    Given I am a user with username "cuterxy" and password "you_guess"
    And there is a post written by me
    And the post is deleted by me
    Then you would not see the post
    When I sign in manually as "cuterxy" with password "you_guess"
    And I visit the post
    Then I should see the post

  Scenario: I can not see a post deleted by moderator, but the moderator and the author can
    Given I am a user with username "cuterxy" and password "you_guess"
    And there is a post written by me
    And there is a moderator of the board that the post belongs to
    And the post is deleted by the moderator
    When I have already signed in as "anther_one" with password "you_guess"
    And I visit the post
    Then I would not see the post
    And I click the "Sign Out" button in the header
    And I sign in manually as "cuterxy" with password "you_guess"
    And I visit the post
    And I should see the post
    And I click the "Sign Out" button in the header
    And I sign in manually as the moderator
    And I visit the post
    And I should see the post
