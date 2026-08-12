# Update channel bookmark

Original OpenAPI operationId: `UpdateChannelBookmark`
- Method: `PATCH`
- Path: `/api/v4/channels/{channel_id}/bookmarks/{bookmark_id}`
- Summary: Update channel bookmark
- Description: Partially update a channel bookmark by providing only the
fields you want to update. Ommited fields will not be
updated. The fields that can be updated are defined in the
request body, all other provided fields will be ignored.

__Minimum server version__: 9.5

##### Permissions
Must have the `edit_bookmark_public_channel` or
`edit_bookmark_private_channel` depending on the channel
type. If the channel is a DM or GM, must be a non-guest
member.

- Tags: bookmarks

## Parameters
- `channel_id` (path, required, string) - Channel GUID
- `bookmark_id` (path, required, string) - Bookmark GUID

## Request body
- required: True
- description: Channel Bookmark object to be updated
- content:
  - `application/json` -> object

## Responses
- `200`: Channel Bookmark update successful
  - `application/json` -> UpdateChannelBookmarkResponse
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
