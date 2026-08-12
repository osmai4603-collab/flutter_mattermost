# Get a list of roles by name

Original OpenAPI operationId: `GetRolesByNames`
- Method: `POST`
- Path: `/api/v4/roles/names`
- Summary: Get a list of roles by name
- Description: Get a list of roles from their names.

##### Permissions
Requires an active session but no other permissions.

__Minimum server version__: 4.9

- Tags: roles

## Parameters
No parameters.

## Request body
- required: True
- description: List of role names
- content:
  - `application/json` -> array of string

## Responses
- `200`: Role list retrieval successful
  - `application/json` -> array of Role
- `400`: No description available.
- `401`: No description available.
- `404`: No description available.
