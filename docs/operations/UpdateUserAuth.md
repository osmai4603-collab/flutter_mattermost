# Update a user's authentication method

Original OpenAPI operationId: `UpdateUserAuth`
- Method: `PUT`
- Path: `/api/v4/users/{user_id}/auth`
- Summary: Update a user's authentication method
- Description: Updates a user's authentication method. This can be used to change them to/from LDAP authentication for example.

For `auth_service` set to `email`, omit `auth_data`; this clears external authentication and switches the user to email authentication. For other authentication services, `auth_data` must be present and non-empty.

__Minimum server version__: 4.6
##### Permissions
Must have the `edit_other_users` permission.

- Tags: users

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
- required: True
- content:
  - `application/json` -> UserAuthData

## Responses
- `200`: User auth update successful
  - `application/json` -> UserAuthData
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
