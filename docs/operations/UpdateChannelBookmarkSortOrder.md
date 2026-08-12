# Update channel bookmark's order

Original OpenAPI operationId: `UpdateChannelBookmarkSortOrder`
- Method: `POST`
- Path: `/api/v4/channels/{channel_id}/bookmarks/{bookmark_id}/sort_order`
- Summary: Update channel bookmark's order
- Description: Updates the order of a channel bookmark, setting its new order
from the parameters and updating the rest of the bookmarks of
the channel to accomodate for this change.

__Minimum server version__: 9.5

##### Permissions
Must have the `order_bookmark_public_channel` or
`order_bookmark_private_channel` depending on the channel
type. If the channel is a DM or GM, must be a non-guest
member.

- Tags: bookmarks

## Parameters
- `channel_id` (path, required, string) - Channel GUID
- `bookmark_id` (path, required, string) - Bookmark GUID

## Request body
- required: False
- content:
  - `application/json` -> number

## Responses
- `200`: Channel Bookmark Sort Order update successful
  - `application/json` -> array of ChannelBookmarkWithFileInfo
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
