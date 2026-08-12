# Move a post (and any posts within that post's thread)

Original OpenAPI operationId: `MoveThread`
- Method: `POST`
- Path: `/api/v4/posts/{post_id}/move`
- Summary: Move a post (and any posts within that post's thread)
- Description: Move a post/thread to another channel.
THIS IS A BETA FEATURE. The API is subject to change without notice.
##### Permissions
Must have `read_channel` permission for the channel the post is in. Must have `write_post` permission for the channel the post is being moved to.

__Minimum server version__: 9.3

- Tags: posts

## Parameters
- `post_id` (path, required, string) - The identifier of the post to move

## Request body
- required: True
- description: The channel identifier of where the post/thread is to be moved
- content:
  - `application/json` -> object

## Responses
- `200`: Post moved successfully
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
