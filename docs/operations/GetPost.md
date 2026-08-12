# Get a post

Original OpenAPI operationId: `GetPost`
- Method: `GET`
- Path: `/api/v4/posts/{post_id}`
- Summary: Get a post
- Description: Get a single post.
##### Permissions
Must have `read_channel` permission for the channel the post is in or if the channel is public, have the `read_public_channels` permission for the team.

- Tags: posts

## Parameters
- `post_id` (path, required, string) - ID of the post to get
- `include_deleted` (query, optional, boolean) - Defines if result should include deleted posts, must have 'manage_system' (admin) permission.

## Request body
No request body.

## Responses
- `200`: Post retrieval successful
  - `application/json` -> Post
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
