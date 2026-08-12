# Get a channel's pinned posts

Original OpenAPI operationId: `GetPinnedPosts`
- Method: `GET`
- Path: `/api/v4/channels/{channel_id}/pinned`
- Summary: Get a channel's pinned posts
- Description: Get a list of pinned posts for channel.
- Tags: channels

## Parameters
- `channel_id` (path, required, string) - Channel GUID

## Request body
No request body.

## Responses
- `200`: The list of channel pinned posts
  - `application/json` -> PostList
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
