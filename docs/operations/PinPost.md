# Pin a post to the channel

Original OpenAPI operationId: `PinPost`
- Method: `POST`
- Path: `/api/v4/posts/{post_id}/pin`
- Summary: Pin a post to the channel
- Description: Pin a post to a channel it is in based from the provided post id string.
##### Permissions
Must be authenticated and have the `read_channel` permission to the channel the post is in.

- Tags: posts

## Parameters
- `post_id` (path, required, string) - Post GUID

## Request body
No request body.

## Responses
- `200`: Pinned post successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
