# Get group stats

Original OpenAPI operationId: `GetGroupStats`
- Method: `GET`
- Path: `/api/v4/groups/{group_id}/stats`
- Summary: Get group stats
- Description: Retrieve the stats of a given group.

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 5.26

- Tags: groups

## Parameters
- `group_id` (path, required, string) - Group GUID

## Request body
No request body.

## Responses
- `200`: Group stats retrieval successful
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
