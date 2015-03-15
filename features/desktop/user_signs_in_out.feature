Feature: user authentication

  Scenario: user signs in
    Given I am a user with username "test_user" and password "password"
    When I sign in manually as "test_user" with password "password"
    Then I would sign in

  Scenario: user signs out
    Given I have already signed in as "test_user" with password "password"
    And I click the "Sign Out" button in the header
    Then I would sign out

  Scenario: fail to sign in by a wrong password
    Given I am a user with username "test_user" and password "password"
    When I sign in manually as "test_user" with password "wrong_password"
    Then I would not sign in
