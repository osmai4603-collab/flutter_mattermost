# Search tokens

Original OpenAPI operationId: `SearchUserAccessTokens`
- Method: `POST`
- Path: `/api/v4/users/tokens/search`
- Summary: Search tokens
- Description: Get a list of tokens based on search criteria provided in the request body. Searches are done against the token id, user id and username.

__Minimum server version__: 4.7

##### Permissions
Must have `manage_system` permission.

- Tags: users

## Parameters
No parameters.

## Request body
- required: True
- description: Search criteria
- content:
  - `application/json` -> object

## Responses
- `200`: Personal access token search successful
  - `application/json` -> array of UserAccessTokenSanitized
