# Update a user's MFA

Original OpenAPI operationId: `UpdateUserMfa`
- Method: `PUT`
- Path: `/api/v4/users/{user_id}/mfa`
- Summary: Update a user's MFA
- Description: Activates multi-factor authentication for the user if `activate` is true and a valid `code` is provided. If activate is false, then `code` is not required and multi-factor authentication is disabled for the user.
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
- `200`: User MFA update successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
