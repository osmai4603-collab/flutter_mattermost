# Link a channel to a group

Original OpenAPI operationId: `LinkGroupSyncableForChannel`
- Method: `POST`
- Path: `/api/v4/groups/{group_id}/channels/{channel_id}/link`
- Summary: Link a channel to a group
- Description: Link a channel to a group.

##### Permissions
Requires `manage_private_channel_members` (private channel) or
`manage_public_channel_members` (public channel) on the target channel.
If this is the group's first linkage into the channel's team context, also
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
- `201`: Channel linked to group
  - `application/json` -> GroupSyncableChannel
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
