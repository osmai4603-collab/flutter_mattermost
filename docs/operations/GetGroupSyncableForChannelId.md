# Get a channel syncable for a group

Original OpenAPI operationId: `GetGroupSyncableForChannelId`
- Method: `GET`
- Path: `/api/v4/groups/{group_id}/channels/{channel_id}`
- Summary: Get a channel syncable for a group
- Description: Get the GroupSyncableChannel object with the provided group and channel identifiers.

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 5.11

- Tags: groups

## Parameters
- `group_id` (path, required, string) - Group GUID
- `channel_id` (path, required, string) - Channel GUID.

## Request body
No request body.

## Responses
- `200`: Channel syncable retrieved
  - `application/json` -> GroupSyncableChannel
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
