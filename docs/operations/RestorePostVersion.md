# Restores a past version of a post

Original OpenAPI operationId: `RestorePostVersion`
- Method: `POST`
- Path: `/api/v4/posts/{post_id}/restore/{restore_version_id}`
- Summary: Restores a past version of a post
- Description: Restores the post with `post_id` to its past version having the ID `restore_version_id`.
##### Permissions
Must have `read_channel` permission for the channel the post is in. Must have `edit_post` permission for the channel the post is being moved to. Must be the author of the post being restored.

__Minimum server version__: 10.5

- Tags: posts

## Parameters
- `post_id` (path, required, string) - The identifier of the post to restore
- `restore_version_id` (path, required, string) - The identifier of the past version of post to restore to

## Request body
No request body.

## Responses
- `200`: Post restored successful
  - `application/json` -> Post
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
