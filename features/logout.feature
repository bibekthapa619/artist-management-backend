Feature: User Logout

  Background: 
    Given the following user exists:
      | first_name | last_name | email                   | password      | role        |
      | John       | Doe       | john.doe@example.com     | password123   | super_admin |
    And the user is logged in with the email "john.doe@example.com" and password "password123"

  Scenario: User logs out with a valid token
    When the user attempts to log out with a valid token
    Then the response status should be 200

  Scenario: User tries to log out with an invalid token
    When the user attempts to log out with an invalid token
    Then the response status should be 401
