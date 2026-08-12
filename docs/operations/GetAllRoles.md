# Get a list of all the roles

Original OpenAPI operationId: `GetAllRoles`
- Method: `GET`
- Path: `/api/v4/roles`
- Summary: Get a list of all the roles
- Description: ##### Permissions

`manage_system` permission is required.

__Minimum server version__: 5.33

- Tags: roles

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Roles retrieval successful
  - `application/json` -> array of Role
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
