# Revoke all sessions from all users.

Original OpenAPI operationId: `RevokeSessionsFromAllUsers`
- Method: `POST`
- Path: `/api/v4/users/sessions/revoke/all`
- Summary: Revoke all sessions from all users.
- Description: For any session currently on the server (including admin) it will be revoked.
Clients will be notified to log out users.

__Minimum server version__: 5.14

##### Permissions
Must have `manage_system` permission.

- Tags: users

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Sessions successfully revoked.
- `401`: No description available.
- `403`: No description available.
