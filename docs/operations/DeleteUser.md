# Deactivate a user account.

Original OpenAPI operationId: `DeleteUser`
- Method: `DELETE`
- Path: `/api/v4/users/{user_id}`
- Summary: Deactivate a user account.
- Description: Deactivates the user and revokes all its sessions by archiving its user object.

As of server version 5.28, optionally use the `permanent=true` query parameter to permanently delete the user for compliance reasons. To use this feature `ServiceSettings.EnableAPIUserDeletion` must be set to `true` in the server's configuration.
##### Permissions
Must be logged in as the user being deactivated or have the `edit_other_users` permission.

- Tags: users

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
No request body.

## Responses
- `200`: User deactivation successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
