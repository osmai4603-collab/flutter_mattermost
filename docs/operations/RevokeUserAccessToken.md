# Revoke a user access token

Original OpenAPI operationId: `RevokeUserAccessToken`
- Method: `POST`
- Path: `/api/v4/users/tokens/revoke`
- Summary: Revoke a user access token
- Description: Revoke a user access token and delete any sessions using the token.

__Minimum server version__: 4.1

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
- `200`: User access token revoke successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
