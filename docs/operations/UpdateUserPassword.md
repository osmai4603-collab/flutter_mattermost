# Update a user's password

Original OpenAPI operationId: `UpdateUserPassword`
- Method: `PUT`
- Path: `/api/v4/users/{user_id}/password`
- Summary: Update a user's password
- Description: Update a user's password. New password must meet password policy set by server configuration. Current password is required if you're updating your own password.
##### Permissions
Must be logged in as the user the password is being changed for or have `manage_system` permission.

- Tags: users

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: User password update successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
