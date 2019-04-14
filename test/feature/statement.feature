Feature: Endpoint Saldo
    As a client,
    I want to get informantions about my account balance

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

@account @statement
Scenario: Get Statement
    Given (api) user creates a GET request to '${vars.api_url}/api/v1/accounts/${vars.account_id}/statement'
      And (api) user sets the following headers to request:
        | "Authorization" | "Bearer ${vars.access_token}" |
     When (api) user sends the request 
     Then (api) the response status should be '200'
      And (api) the JSON response key '$[0].amount' should have value equals to '100000'
      And (api) the JSON response key '$[0].description' should have value equals to ''
      And (api) the JSON response key '$[0].id' should have value equals to 'e1b71bb8-9c94-456b-a6a9-03eceff1aba4'
      And (api) the JSON response key '$[0].status' should have value equals to 'FINISHED'
      And (api) the JSON response key '$[0].type' should have value equals to 'internal'
      And (api) the JSON response key '$[0].operation' should have value equals to 'credit'
      And (api) the JSON response key '$[0].counter_party.account.institution_name' should have value equals to 'Stone Pagamentos S.A.'
      And (api) the JSON response key '$[0].counter_party.account.institution' should have value equals to '16501555'
      And (api) the JSON response key '$[0].counter_party.account.account_code' should have value equals to '667857'
      And (api) the JSON response key '$[0].counter_party.entity.document' should have value equals to '39572379801'
      And (api) the JSON response key '$[0].counter_party.entity.document_type' should have value equals to 'cpf'
      And (api) the JSON response key '$[0].counter_party.entity.name' should have value equals to 'Eduardo Machado Freire'