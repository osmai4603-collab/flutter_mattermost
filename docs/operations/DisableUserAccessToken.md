# Disable personal access token

Original OpenAPI operationId: `DisableUserAccessToken`
- Method: `POST`
- Path: `/api/v4/users/tokens/disable`
- Summary: Disable personal access token
- Description: Disable a personal access token and delete any sessions using the token. The token can be re-enabled using `/users/tokens/enable`.

__Minimum server version__: 4.4

##### Permissions
Must have `revoke_user_access_token` permission. For non-self requests, must also have the `edit_other_users` permission.

- Tags: users

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Personal access token disable successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
