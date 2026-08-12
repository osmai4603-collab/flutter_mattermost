# Rotate a personal access token

Original OpenAPI operationId: `RotateUserAccessToken`
- Method: `POST`
- Path: `/api/v4/users/tokens/rotate`
- Summary: Rotate a personal access token
- Description: Generate a new secret for an existing personal access token, immediately invalidating the old secret and any sessions that used it. The response includes the new token secret (shown once, like token creation).

__Minimum server version__: 10.10

##### Permissions
Must have `create_user_access_token` permission. For non-self requests, must also have the `edit_other_users` permission. To rotate a token belonging to a system admin, must also have the `manage_system` permission. OAuth sessions cannot use this endpoint.

- Tags: users

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Personal access token rotation successful; response includes the new secret
  - `application/json` -> UserAccessToken
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
