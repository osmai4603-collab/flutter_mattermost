# Get team syncables for a group

Original OpenAPI operationId: `GetGroupSyncablesTeams`
- Method: `GET`
- Path: `/api/v4/groups/{group_id}/teams`
- Summary: Get team syncables for a group
- Description: Retrieve the list of team syncables associated with the group.

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 5.11

- Tags: groups

## Parameters
- `group_id` (path, required, string) - Group GUID

## Request body
No request body.

## Responses
- `200`: Team syncables retrieved
  - `application/json` -> array of GroupSyncableTeams
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
