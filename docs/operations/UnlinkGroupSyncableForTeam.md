# Unlink a team from a group

Original OpenAPI operationId: `UnlinkGroupSyncableForTeam`
- Method: `DELETE`
- Path: `/api/v4/groups/{group_id}/teams/{team_id}/link`
- Summary: Unlink a team from a group
- Description: Delete a link between a team and a group.

##### Permissions
Requires `invite_user` on the target team, or `sysconsole_write_user_management_groups`.
If the group has `allow_reference` disabled, also requires `sysconsole_read_user_management_groups`.

__Minimum server version__: 5.11

- Tags: groups

## Parameters
- `group_id` (path, required, string) - Group GUID
- `team_id` (path, required, string) - Team GUID.

## Request body
No request body.

## Responses
- `200`: Team unlinked from group
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
