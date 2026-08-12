# Get file info for post

Original OpenAPI operationId: `GetFileInfosForPost`
- Method: `GET`
- Path: `/api/v4/posts/{post_id}/files/info`
- Summary: Get file info for post
- Description: Gets a list of file information objects for the files attached to a post.
##### Permissions
Must have `read_channel` permission for the channel the post is in.

- Tags: posts

## Parameters
- `post_id` (path, required, string) - ID of the post
- `include_deleted` (query, optional, boolean) - Defines if result should include deleted posts, must have 'manage_system' (admin) permission.

## Request body
No request body.

## Responses
- `200`: File info retrieval successful
  - `application/json` -> array of FileInfo
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
