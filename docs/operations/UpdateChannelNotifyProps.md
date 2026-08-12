# Update channel notifications

Original OpenAPI operationId: `UpdateChannelNotifyProps`
- Method: `PUT`
- Path: `/api/v4/channels/{channel_id}/members/{user_id}/notify_props`
- Summary: Update channel notifications
- Description: Update a user's notification properties for a channel. Only the provided fields are updated.
##### Permissions
Must be logged in as the user or have `edit_other_users` permission.

- Tags: channels

## Parameters
- `channel_id` (path, required, string) - Channel GUID
- `user_id` (path, required, string) - User GUID

## Request body
- required: True
- content:
  - `application/json` -> ChannelNotifyProps

## Responses
- `200`: Channel notification properties update successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
