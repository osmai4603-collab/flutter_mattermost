# Revoke all active sessions for a user

Original OpenAPI operationId: `RevokeAllSessions`
- Method: `POST`
- Path: `/api/v4/users/{user_id}/sessions/revoke/all`
- Summary: Revoke all active sessions for a user
- Description: Revokes all user sessions from the provided user id and session id strings.
##### Permissions
Must be logged in as the user being updated or have the `edit_other_users` permission.
__Minimum server version__: 4.4

- Tags: users

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
No request body.

## Responses
- `200`: User sessions revoked successfully
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
