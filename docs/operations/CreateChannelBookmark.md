# Create channel bookmark

Original OpenAPI operationId: `CreateChannelBookmark`
- Method: `POST`
- Path: `/api/v4/channels/{channel_id}/bookmarks`
- Summary: Create channel bookmark
- Description: Creates a new channel bookmark for this channel.

__Minimum server version__: 9.5

##### Permissions
Must have the `add_bookmark_public_channel` or
`add_bookmark_private_channel` depending on the channel
type. If the channel is a DM or GM, must be a non-guest
member.

- Tags: bookmarks

## Parameters
- `channel_id` (path, required, string) - Channel GUID

## Request body
- required: True
- description: Channel Bookmark object to be created
- content:
  - `application/json` -> object

## Responses
- `201`: Channel Bookmark creation successful
  - `application/json` -> ChannelBookmarkWithFileInfo
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
