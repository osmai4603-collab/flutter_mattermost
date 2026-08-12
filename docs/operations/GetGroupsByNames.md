# Get groups by name

Original OpenAPI operationId: `GetGroupsByNames`
- Method: `POST`
- Path: `/api/v4/groups/names`
- Summary: Get groups by name
- Description: Get a list of groups based on a provided list of names.

##### Permissions
Requires an active session but no other permissions.

__Minimum server version__: 11.0

- Tags: groups

## Parameters
No parameters.

## Request body
- required: True
- description: List of group names
- content:
  - `application/json` -> array of string

## Responses
- `200`: Group list retrieval successfully
  - `application/json` -> array of Group
- `400`: No description available.
- `401`: No description available.
- `501`: No description available.
