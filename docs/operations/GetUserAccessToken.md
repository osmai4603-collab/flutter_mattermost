# Get a user access token

Original OpenAPI operationId: `GetUserAccessToken`
- Method: `GET`
- Path: `/api/v4/users/tokens/{token_id}`
- Summary: Get a user access token
- Description: Get a user access token. Does not include the actual authentication token.

__Minimum server version__: 4.1

##### Permissions
Must have `read_user_access_token` permission. For non-self requests, must also have the `edit_other_users` permission.

- Tags: users

## Parameters
- `token_id` (path, required, string) - User access token GUID

## Request body
No request body.

## Responses
- `200`: User access token retrieval successful
  - `application/json` -> UserAccessTokenSanitized
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
