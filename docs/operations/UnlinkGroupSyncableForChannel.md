# Unlink a channel from a group

Original OpenAPI operationId: `UnlinkGroupSyncableForChannel`
- Method: `DELETE`
- Path: `/api/v4/groups/{group_id}/channels/{channel_id}/link`
- Summary: Unlink a channel from a group
- Description: Delete a link between a channel and a group.

##### Permissions
Requires `manage_private_channel_members` (private channel) or
`manage_public_channel_members` (public channel) on the target channel.
If unlinking would leave the group with no remaining linkage in that channel's team context (last/only linkage for that team), also
requires `invite_user` on the team, or `sysconsole_write_user_management_groups`.
If the group has `allow_reference` disabled, also requires `sysconsole_read_user_management_groups`.

__Minimum server version__: 5.11

- Tags: groups

## Parameters
- `group_id` (path, required, string) - Group GUID
- `channel_id` (path, required, string) - Channel GUID.

## Request body
No request body.

## Responses
- `200`: Channel unlinked from group
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
