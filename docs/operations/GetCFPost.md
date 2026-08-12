# Get a flagged post with all its content.

Original OpenAPI operationId: `GetCFPost`
- Method: `GET`
- Path: `/api/v4/content_flagging/post/{post_id}`
- Summary: Get a flagged post with all its content.
- Description: Returns the flagged post with all its data, even if it is soft-deleted. This endpoint is only accessible by content reviewers. A content reviewer can only fetch flagged posts from this API if the post is indeed flagged and they are a content reviewer of the post's team.
An enterprise advanced license is required.

- Tags: Content Flagging

## Parameters
- `post_id` (path, required, string) - The ID of the post to retrieve

## Request body
No request body.

## Responses
- `200`: The flagged post is fetched correctly
  - `application/json` -> Post
- `403`: Forbidden - User does not have permission to access this post, or is not a reviewer of the post's team.
- `404`: Post not found or feature is disabled via the feature flag.
- `500`: Internal server error.
- `501`: Feature is disabled either via config or an Enterprise Advanced license is not available.
