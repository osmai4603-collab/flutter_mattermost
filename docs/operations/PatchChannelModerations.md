# Update a channel's moderation settings.

Original OpenAPI operationId: `PatchChannelModerations`
- Method: `PUT`
- Path: `/api/v4/channels/{channel_id}/moderations/patch`
- Summary: Update a channel's moderation settings.
- Description: ##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 5.22

- Tags: channels

## Parameters
- `channel_id` (path, required, string) - Channel GUID

## Request body
- required: True
- content:
  - `application/json` -> ChannelModerationPatch

## Responses
- `200`: Patched successfully
  - `application/json` -> array of ChannelModeration
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
