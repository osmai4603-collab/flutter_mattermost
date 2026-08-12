# Get post info

Original OpenAPI operationId: `GetPostInfo`
- Method: `GET`
- Path: `/api/v4/posts/{post_id}/info`
- Summary: Get post info
- Description: Get additional metadata and access information for a post.
##### Permissions
Must be able to access the post's team and channel context.

- Tags: posts

## Parameters
- `post_id` (path, required, string) - Post ID

## Request body
No request body.

## Responses
- `200`: Post info retrieval successful
  - `application/json` -> PostInfo
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
