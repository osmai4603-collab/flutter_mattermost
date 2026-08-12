# Delete channel bookmark

Original OpenAPI operationId: `DeleteChannelBookmark`
- Method: `DELETE`
- Path: `/api/v4/channels/{channel_id}/bookmarks/{bookmark_id}`
- Summary: Delete channel bookmark
- Description: Archives a channel bookmark. This will set the `deleteAt` to
the current timestamp in the database.

__Minimum server version__: 9.5

##### Permissions
Must have the `delete_bookmark_public_channel` or
`delete_bookmark_private_channel` depending on the channel
type. If the channel is a DM or GM, must be a non-guest
member.

- Tags: bookmarks

## Parameters
- `channel_id` (path, required, string) - Channel GUID
- `bookmark_id` (path, required, string) - Bookmark GUID

## Request body
No request body.

## Responses
- `200`: Channel Bookmark deletion successful
  - `application/json` -> ChannelBookmarkWithFileInfo
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
