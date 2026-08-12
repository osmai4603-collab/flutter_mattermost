# Get a team syncable for a group

Original OpenAPI operationId: `GetGroupSyncableForTeamId`
- Method: `GET`
- Path: `/api/v4/groups/{group_id}/teams/{team_id}`
- Summary: Get a team syncable for a group
- Description: Get the GroupSyncableTeam object with the provided group and team identifiers.

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 5.11

- Tags: groups

## Parameters
- `group_id` (path, required, string) - Group GUID
- `team_id` (path, required, string) - Team GUID.

## Request body
No request body.

## Responses
- `200`: Team syncable retrieved
  - `application/json` -> GroupSyncableTeam
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
