Feature: Test

@test
Scenario: Lading variables from params config file
    Given user stores the following list of variables:
        | "base_url" | "${params.[$.default.base_url]}" |
        | "username" | "${params.[$.default.username]}" |
        | "password" | "${params.[$.default.password]}" | 
        | "api_url"  | "${params.[$.default.api_url]}"  |

@test
Scenario: Getting credentials
    Given (api) user creates a POST request to '${vars.base_url}/auth/realms/stone_bank/protocol/openid-connect/token'
     When (api) user sets the following headers to request:
        | "Content-Type" | "application/x-www-form-urlencoded" |
      And (api) user add the following value to BODY request:
        """
        client_id=admin-cli&username=${vars.username}&password=${vars.password}&grant_type=password
        """
      And (api) user sends the request
     Then (api) the response status should be '200'
      And (api) the JSON response key '$.expires_in' should have value equals to '900'
      And (api) the JSON response key '$.refresh_expires_in' should have value equals to '1800'
      And (api) the JSON response key '$.token_type' should have value equals to 'bearer'
      And (api) user stores the value '$.access_token' from response in variable 'access_token' 
      
@test
Scenario: Get account ID
    Given (api) user creates a GET request to '${vars.api_url}/api/v1/accounts'
     When (api) user sets the following headers to request:
        | "Authorization" | "Bearer ${vars.access_token}" |
      And (api) user sends the request
     Then (api) the response status should be '200'
      And (api) the JSON response key '$[0].account_code' should have value equals to '396705'
      And (api) the JSON response key '$[0].owner_document' should have value equals to '55904201052'
      And (api) the JSON response key '$[0].owner_name' should have value equals to 'Andre Sakai'
      And (api) the JSON response key '$[0].id' should have value equals to '7fcc00d5-850f-4e19-94ca-f74e40976d53'
      And (api) the JSON response key '$[0].branch_code' should have value equals to '1'
      And (api) the JSON response key '$[0].owner_id' should have value equals to 'user:7c12386b-c1f8-4129-bf26-1d2e813c3536'
      And (api) user stores the value '$[0].id' from response in variable 'user_id'