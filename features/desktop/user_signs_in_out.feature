Feature: user authentication

  Scenario: user signs in
    Given a user with username "ohai" and password "secret"
    When I sign in manually as "ohai" with password "secret"
    Then I should be on the home page
    And I should in the signed-in status

  Scenario: user signs out
    Given I am signed in
    And I click "sign out" in the header
    And I follow "Log out"
    Then I should be on the home page
    And I should be in the signed-out status
