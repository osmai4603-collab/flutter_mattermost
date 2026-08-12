# Flag a post

Original OpenAPI operationId: `PostCFPostFlag`
- Method: `POST`
- Path: `/api/v4/content_flagging/post/{post_id}/flag`
- Summary: Flag a post
- Description: Flags a post with a reason and a comment. The user must have access to the channel to which the post belongs to.
An enterprise advanced license is required.

- Tags: Content Flagging

## Parameters
- `post_id` (path, required, string) - The ID of the post to be flagged

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Post flagged successfully
  - `application/json` -> StatusOK
- `400`: Bad request - Invalid input data or missing required fields.
- `403`: Forbidden - User does not have permission to flag this post.
- `404`: Post not found or feature is disabled via the feature flag.
- `500`: Internal server error.
- `501`: Feature is disabled either via config or an Enterprise Advanced license is not available.
