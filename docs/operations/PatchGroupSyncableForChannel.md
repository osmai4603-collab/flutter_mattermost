# Patch a channel syncable for a group

Original OpenAPI operationId: `PatchGroupSyncableForChannel`
- Method: `PUT`
- Path: `/api/v4/groups/{group_id}/channels/{channel_id}/patch`
- Summary: Patch a channel syncable for a group
- Description: Partially update a GroupSyncableChannel by providing only the fields you want to update. Omitted fields will not be updated.
##### Permissions Must have `manage_system` permission.
__Minimum server version__: 5.11

- Tags: groups

## Parameters
- `group_id` (path, required, string) - Group GUID
- `channel_id` (path, required, string) - Channel GUID.

## Request body
- required: True
- description: GroupSyncableChannel object that is to be updated
- content:
  - `application/json` -> object

## Responses
- `200`: Channel syncable patched
  - `application/json` -> GroupSyncableChannel
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
