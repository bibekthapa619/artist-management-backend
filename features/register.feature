Feature: User Registration API

  Scenario: Register a new user with valid attributes
    When A new user registers with the following details:
      | first_name | last_name | email                   | password      |
      | John       | Doe       | john.doe@example.com     | password123   |
    Then the response status should be 200
    And the user should be created with the following details:
      | first_name | last_name | email                   | role        |
      | John       | Doe       | john.doe@example.com     | super_admin |

  Scenario Outline: Register a new user with invalid attributes
    When A new user registers with the following details:
      | first_name | last_name | email                   | password      |
      | <first_name> | <last_name> | <email>              | <password>    |
    Then the response status should be 422

    Examples:
      | first_name | last_name | email           | password |
      |            | Doe       | john.doe@example.com | password123   |
      | John       |            | john.doe@example.com | password123   |
      | John       | Doe       | invalidemail    | password123   |
      | John       | Doe       | john.doe@example.com | short         |
      |            |            | invalidemail    | short         |
