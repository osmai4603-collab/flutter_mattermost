# Get a group

Original OpenAPI operationId: `GetGroup`
- Method: `GET`
- Path: `/api/v4/groups/{group_id}`
- Summary: Get a group
- Description: Get group from the provided group id string

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 5.11

- Tags: groups

## Parameters
- `group_id` (path, required, string) - Group GUID

## Request body
No request body.

## Responses
- `200`: Group retrieval successful
  - `application/json` -> Group
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
