# Get channel syncables for a group

Original OpenAPI operationId: `GetGroupSyncablesChannels`
- Method: `GET`
- Path: `/api/v4/groups/{group_id}/channels`
- Summary: Get channel syncables for a group
- Description: Retrieve the list of channel syncables associated with the group.

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 5.11

- Tags: groups

## Parameters
- `group_id` (path, required, string) - Group GUID

## Request body
No request body.

## Responses
- `200`: Channel syncables retrieved
  - `application/json` -> array of GroupSyncableChannels
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
