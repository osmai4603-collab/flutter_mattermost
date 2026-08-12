# Get a role

Original OpenAPI operationId: `GetRole`
- Method: `GET`
- Path: `/api/v4/roles/{role_id}`
- Summary: Get a role
- Description: Get a role from the provided role id.

##### Permissions
Requires an active session but no other permissions.

__Minimum server version__: 4.9

- Tags: roles

## Parameters
- `role_id` (path, required, string) - Role GUID

## Request body
No request body.

## Responses
- `200`: Role retrieval successful
  - `application/json` -> Role
- `401`: No description available.
- `404`: No description available.
