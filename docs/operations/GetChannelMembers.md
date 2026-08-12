# Get channel members

Original OpenAPI operationId: `GetChannelMembers`
- Method: `GET`
- Path: `/api/v4/channels/{channel_id}/members`
- Summary: Get channel members
- Description: Get a page of members for a channel.
##### Permissions
`read_channel` permission for the channel.

- Tags: channels

## Parameters
- `channel_id` (path, required, string) - Channel GUID
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of members per page.

## Request body
No request body.

## Responses
- `200`: Channel members retrieval successful
  - `application/json` -> array of ChannelMember
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
