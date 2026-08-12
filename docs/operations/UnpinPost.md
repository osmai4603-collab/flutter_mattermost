# Unpin a post to the channel

Original OpenAPI operationId: `UnpinPost`
- Method: `POST`
- Path: `/api/v4/posts/{post_id}/unpin`
- Summary: Unpin a post to the channel
- Description: Unpin a post to a channel it is in based from the provided post id string.
##### Permissions
Must be authenticated and have the `read_channel` permission to the channel the post is in.

- Tags: posts

## Parameters
- `post_id` (path, required, string) - Post GUID

## Request body
No request body.

## Responses
- `200`: Unpinned post successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
