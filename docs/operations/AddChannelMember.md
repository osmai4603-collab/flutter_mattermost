# Add user(s) to channel

Original OpenAPI operationId: `AddChannelMember`
- Method: `POST`
- Path: `/api/v4/channels/{channel_id}/members`
- Summary: Add user(s) to channel
- Description: Add a user(s) to a channel by creating a channel member object(s).
- Tags: channels

## Parameters
- `channel_id` (path, required, string) - The channel ID

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `201`: Channel member creation successful
  - `application/json` -> ChannelMember
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
