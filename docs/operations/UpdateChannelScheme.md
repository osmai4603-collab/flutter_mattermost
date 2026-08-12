# Set a channel's scheme

Original OpenAPI operationId: `UpdateChannelScheme`
- Method: `PUT`
- Path: `/api/v4/channels/{channel_id}/scheme`
- Summary: Set a channel's scheme
- Description: Set a channel's scheme, more specifically sets the scheme_id value of a channel record.

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 4.10

- Tags: channels

## Parameters
- `channel_id` (path, required, string) - Channel GUID

## Request body
- required: True
- description: Scheme GUID
- content:
  - `application/json` -> object

## Responses
- `200`: Update channel scheme successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
