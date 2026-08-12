# Remove user from channel

Original OpenAPI operationId: `RemoveUserFromChannel`
- Method: `DELETE`
- Path: `/api/v4/channels/{channel_id}/members/{user_id}`
- Summary: Remove user from channel
- Description: Delete a channel member, effectively removing them from a channel.

In server version 5.3 and later, channel members can only be deleted from public or private channels.
##### Permissions
`manage_public_channel_members` permission if the channel is public.
`manage_private_channel_members` permission if the channel is private.

- Tags: channels

## Parameters
- `channel_id` (path, required, string) - Channel GUID
- `user_id` (path, required, string) - User GUID

## Request body
No request body.

## Responses
- `200`: Channel member deletion successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
