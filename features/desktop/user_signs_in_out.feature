Feature: user authentication

  Scenario: user signs in
    Given I am a user with username "test_user" and password "password"
    When I sign in
    Then I should sign in successfully

  Scenario: user signs out
    Given I am a user with username "test_user" and password "password"
    And I sign in
    And I click the "Sign Out" button in the header
    Then I should sign out successfully
