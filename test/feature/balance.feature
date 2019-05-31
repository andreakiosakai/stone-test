Feature: Endpoint Saldo
    As a client,
    I want to get informantions about my account balance
    #Need to be refactored

Background: Load variables from params, get authorization and get account ID
    Given user stores the following list of variables:
            | "base_url" | "${params.[$.default.base_url]}" |
            | "username" | "${params.[$.default.username]}" |
            | "password" | "${params.[$.default.password]}" | 
            | "api_url"  | "${params.[$.default.api_url]}"  |
      And (api) user creates a POST request to '${vars.base_url}/auth/realms/stone_bank/protocol/openid-connect/token'
      And (api) user sets the following headers to request:
        | "Content-Type" | "application/x-www-form-urlencoded" |
      And (api) user add the following value to BODY request:
        """
        client_id=admin-cli&username=${vars.username}&password=${vars.password}&grant_type=password
        """
      And (api) user sends the request
      And (api) the response status should be '200'
      And (api) user stores the value '$.access_token' from response in variable 'access_token' 
      And (api) user creates a GET request to '${vars.api_url}/api/v1/accounts'
      And (api) user sets the following headers to request:
        | "Authorization" | "Bearer ${vars.access_token}" |
      And (api) user sends the request
      And (api) the response status should be '200'
      And (api) user stores the value '$[0].id' from response in variable 'account_id'

@stone @account @balance
Scenario: Balance - Get balance
    Given (api) user creates a GET request to '${vars.api_url}/api/v1/accounts/${vars.account_id}/balance'
      And (api) user sets the following headers to request:
        | "Authorization" | "Bearer ${vars.access_token}" |
     When (api) user sends the request
     Then (api) the response status should be '200'
      And (api) the JSON response key '$.balance' should have value equals to '100000'
      And (api) the JSON response key '$.blocked_balance' should have value equals to '0'
      And (api) the JSON response key '$.scheduled_balance' should have value equals to '0'

@stone @account @balance
Scenario: Balance - Wrong account id
    Given (api) user creates a GET request to '${vars.api_url}/api/v1/accounts/123/balance'
      And (api) user sets the following headers to request:
        | "Authorization" | "Bearer ${vars.access_token}" |
     When (api) user sends the request
     Then (api) the response status should be '403'
      And (api) the JSON response key '$.type' should have value equals to 'srn:error:unauthorized'