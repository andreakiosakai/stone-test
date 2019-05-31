Feature: Transfer between internal accounts simulation
    As a client,
    I want to simulate a internal transfer to another account
    Needs to be improved

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

@stone @internal_simulation
Scenario: Transfer Simulation - Making a internal transfer simulation
    Given (api) user creates a POST request to '${vars.api_url}/api/v1/dry_run/internal_transfers'
      And (api) user sets the following headers to request:
        | "Authorization" | "Bearer ${vars.access_token}" |
        | "Content-type"  | "application/json"            |
      And (api) user add the request BODY from the resource 'test/templates/transfer-body.json'
      And (api) user fills '$.amount' with '100'
      And (api) user fills '$.account_id' with '${vars.account_id}'
      And (api) user fills '$.target_account_code' with '307942'
      And (api) user fills '$.description' with 'teste'
     When (api) user sends the request
     Then (api) the response status should be '202'
      And (api) the JSON response key '$.amount' should have value equals to '100'
      And (api) the JSON response key '$.description' should have value equals to 'teste'
      And (api) the JSON response key '$.status' should have value equals to 'APPROVED'
      And (api) the JSON response key '$.target_account_code' should have value equals to '307942'
      And (api) the JSON response key '$.target_account_owner_name' should have value equals to 'Victor Nascimento'
      
@stone @internal_simulation
Scenario: Transfer Simulation - Making a invalid transfer simulation with a invalid account id
    Given (api) user creates a POST request to '${vars.api_url}/api/v1/dry_run/internal_transfers'
      And (api) user sets the following headers to request:
        | "Authorization" | "Bearer ${vars.access_token}" |
        | "Content-type"  | "application/json"            |
      And (api) user add the request BODY from the resource 'test/templates/transfer-body.json'
      And (api) user fills '$.amount' with '100'
      And (api) user fills '$.account_id' with '123'
      And (api) user fills '$.target_account_code' with '307942'
      And (api) user fills '$.description' with 'test refused'
     When (api) user sends the request
     Then (api) the response status should be '403'
      And (api) the JSON response key '$.type' should have value equals to 'srn:error:unauthorized'
      
@stone @internal_simulation
Scenario: Transfer Simulation - Making a invalid transfer simulation to a invalid target account
    Given (api) user creates a POST request to '${vars.api_url}/api/v1/dry_run/internal_transfers'
      And (api) user sets the following headers to request:
        | "Authorization" | "Bearer ${vars.access_token}" |
        | "Content-type"  | "application/json"            |
      And (api) user add the request BODY from the resource 'test/templates/transfer-body.json'
      And (api) user fills '$.amount' with '100'
      And (api) user fills '$.account_id' with '${vars.account_id}'
      And (api) user fills '$.target_account_code' with '11111111111'
      And (api) user fills '$.description' with 'test refused'
     When (api) user sends the request
     Then (api) the response status should be '422'
      And (api) the JSON response key '$.type' should have value equals to 'srn:error:target_account_not_found'

@stone @internal_simulation
Scenario: Transfer Simulation - Making a invalid transfer simulation with an invalid amount (not integer)
    Given (api) user creates a POST request to '${vars.api_url}/api/v1/dry_run/internal_transfers'
      And (api) user sets the following headers to request:
        | "Authorization" | "Bearer ${vars.access_token}" |
        | "Content-type"  | "application/json"            |
      And (api) user add the request BODY from the resource 'test/templates/transfer-body.json'
      And (api) user fills '$.amount' with 'aahdhasd'
      And (api) user fills '$.account_id' with '${vars.account_id}'
      And (api) user fills '$.target_account_code' with '307942'
      And (api) user fills '$.description' with 'test refused'
     When (api) user sends the request
     Then (api) the response status should be '400'
      And (api) the JSON response key '$.type' should have value equals to 'srn:error:validation'
      And (api) the JSON response key '$.validation_errors[0].error' should have value equals to 'not_an_integer'
      And (api) the JSON response key '$.validation_errors[0].path[0]' should have value equals to 'amount'

@stone @internal_simulation
Scenario: Transfer Simulation - Making a invalid transfer simulation with zero amount
    Given (api) user creates a POST request to '${vars.api_url}/api/v1/dry_run/internal_transfers'
      And (api) user sets the following headers to request:
        | "Authorization" | "Bearer ${vars.access_token}" |
        | "Content-type"  | "application/json"            |
      And (api) user add the request BODY from the resource 'test/templates/transfer-body.json'
      And (api) user fills '$.amount' with '0'
      And (api) user fills '$.account_id' with '${vars.account_id}'
      And (api) user fills '$.target_account_code' with '307942'
      And (api) user fills '$.description' with 'test refused'
     When (api) user sends the request
     Then (api) the response status should be '400'
      And (api) the JSON response key '$.type' should have value equals to 'srn:error:validation'
      And (api) the JSON response key '$.validation_errors[0].error' should have value equals to 'not_greater'
      And (api) the JSON response key '$.validation_errors[0].path[0]' should have value equals to 'amount'
