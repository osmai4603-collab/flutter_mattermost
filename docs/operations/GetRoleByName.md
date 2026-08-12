# Get a role

Original OpenAPI operationId: `GetRoleByName`
- Method: `GET`
- Path: `/api/v4/roles/name/{role_name}`
- Summary: Get a role
- Description: Get a role from the provided role name.

##### Permissions
Requires an active session but no other permissions.

__Minimum server version__: 4.9

- Tags: roles

## Parameters
- `role_name` (path, required, string) - Role Name

## Request body
No request body.

## Responses
- `200`: Role retrieval successful
  - `application/json` -> Role
- `401`: No description available.
- `404`: No description available.
