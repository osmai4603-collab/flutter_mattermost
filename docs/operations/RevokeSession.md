# Revoke a user session

Original OpenAPI operationId: `RevokeSession`
- Method: `POST`
- Path: `/api/v4/users/{user_id}/sessions/revoke`
- Summary: Revoke a user session
- Description: Revokes a user session from the provided user id and session id strings.
##### Permissions
Must be logged in as the user being updated or have the `edit_other_users` permission.

- Tags: users

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: User session revoked successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
