Feature: User login

  Scenario: User logs in with valid credentials
    Given the following user exists:
      | first_name | last_name | email                   | password      | role        |
      | John       | Doe       | john.doe@example.com    | password123   | super_admin |
    When the user attempts to log in with:
      | email                     | password      |
      | john.doe@example.com      | password123   |
    Then the response status should be 200
    And the response should contain a token

  Scenario: User logs in with invalid credentials
    Given the following user exists:
      | first_name | last_name | email                   | password      | role        |
      | John       | Doe       | john.doe@example.com    | password123   | super_admin |
    When the user attempts to log in with:
      | email                     | password      |
      | wrong.email@example.com    | wrongpassword |
    Then the response status should be 422
