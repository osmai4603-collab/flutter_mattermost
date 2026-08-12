# Patch a team syncable for a group

Original OpenAPI operationId: `PatchGroupSyncableForTeam`
- Method: `PUT`
- Path: `/api/v4/groups/{group_id}/teams/{team_id}/patch`
- Summary: Patch a team syncable for a group
- Description: Partially update a GroupSyncableTeam by providing only the fields you want to update. Omitted fields will not be updated.
##### Permissions Must have `manage_system` permission.
__Minimum server version__: 5.11

- Tags: groups

## Parameters
- `group_id` (path, required, string) - Group GUID
- `team_id` (path, required, string) - Team GUID.

## Request body
- required: True
- description: GroupSyncableTeam object that is to be updated
- content:
  - `application/json` -> object

## Responses
- `200`: Team syncable patched
  - `application/json` -> GroupSyncableTeam
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
