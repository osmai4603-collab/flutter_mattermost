# Get channel bookmarks for Channel

Original OpenAPI operationId: `ListChannelBookmarksForChannel`
- Method: `GET`
- Path: `/api/v4/channels/{channel_id}/bookmarks`
- Summary: Get channel bookmarks for Channel
- Description: __Minimum server version__: 9.5

- Tags: bookmarks

## Parameters
- `channel_id` (path, required, string) - Channel GUID
- `bookmarks_since` (query, optional, number) - Timestamp to filter the bookmarks with. If set, the
endpoint returns bookmarks that have been added, updated
or deleted since its value


## Request body
No request body.

## Responses
- `200`: Channel Bookmarks retrieval successful
  - `application/json` -> array of ChannelBookmarkWithFileInfo
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
