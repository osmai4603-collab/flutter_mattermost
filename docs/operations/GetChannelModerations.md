# Get information about channel's moderation.

Original OpenAPI operationId: `GetChannelModerations`
- Method: `GET`
- Path: `/api/v4/channels/{channel_id}/moderations`
- Summary: Get information about channel's moderation.
- Description: ##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 5.22

- Tags: channels

## Parameters
- `channel_id` (path, required, string) - Channel GUID

## Request body
No request body.

## Responses
- `200`: Retreived successfully
  - `application/json` -> array of ChannelModeration
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
