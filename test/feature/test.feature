Feature: Test

@test
Scenario: Lading variables from params config file
    Given user stores the following list of variables:
        | "base_url" | "${params.[$.default.base_url]}" | 

@test
Scenario: Getting credentials
    Given (api) user creates a POST request to '${vars.base_url}/auth/realms/stone_bank/protocol/openid-connect/token'
     When (api) user sets the following headers to request:
        | "Content-Type" | "application/x-www-form-urlencoded" |
      And (api) user add the following value to BODY request:
        """
        client_id=admin-cli&username=andreakiosakai%40gmail.com&password=ABC123teste&grant_type=password
        """
      And (api) user sends the request
     Then (api) the response status should be '200'
      And (api) the JSON response key '$.expires_in' should have value equals to '900'
      And (api) the JSON response key '$.refresh_expires_in' should have value equals to '1800'
      And (api) the JSON response key '$.token_type' should have value equals to 'bearer'
      And (api) user stores the value '$.access_token' from response in variable 'access_token' 
      