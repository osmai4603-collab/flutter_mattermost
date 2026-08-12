# Get unread messages

Original OpenAPI operationId: `GetChannelUnread`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/channels/{channel_id}/unread`
- Summary: Get unread messages
- Description: Get the total unread messages and mentions for a channel for a user.
##### Permissions
Must be logged in as user and have the `read_channel` permission, or have `edit_other_usrs` permission.

- Tags: channels

## Parameters
- `user_id` (path, required, string) - User GUID
- `channel_id` (path, required, string) - Channel GUID

## Request body
No request body.

## Responses
- `200`: Channel unreads retrieval successful
  - `application/json` -> ChannelUnread
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
