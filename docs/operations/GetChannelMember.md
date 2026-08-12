# Get channel member

Original OpenAPI operationId: `GetChannelMember`
- Method: `GET`
- Path: `/api/v4/channels/{channel_id}/members/{user_id}`
- Summary: Get channel member
- Description: Get a channel member.
##### Permissions
`read_channel` permission for the channel.

- Tags: channels

## Parameters
- `channel_id` (path, required, string) - Channel GUID
- `user_id` (path, required, string) - User GUID

## Request body
No request body.

## Responses
- `200`: Channel member retrieval successful
  - `application/json` -> ChannelMember
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
