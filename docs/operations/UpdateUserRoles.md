# Update a user's roles

Original OpenAPI operationId: `UpdateUserRoles`
- Method: `PUT`
- Path: `/api/v4/users/{user_id}/roles`
- Summary: Update a user's roles
- Description: Update a user's system-level roles. Valid user roles are "system_user", "system_admin" or both of them. Overwrites any previously assigned system-level roles.
##### Permissions
Must have the `manage_roles` permission.

- Tags: users

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
- required: True
- description: Space-delimited system roles to assign to the user
- content:
  - `application/json` -> object

## Responses
- `200`: User roles update successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
