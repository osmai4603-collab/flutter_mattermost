# Remove a flagged post

Original OpenAPI operationId: `RemoveCFPost`
- Method: `PUT`
- Path: `/api/v4/content_flagging/post/{post_id}/remove`
- Summary: Remove a flagged post
- Description: Permanently removes a flagged post and all its associated contents from the system. This action is typically performed by content reviewers after they have reviewed the flagged content. This action is irreversible.
The user must be a content reviewer of the team to which the post belongs to.
An enterprise advanced license is required.

- Tags: Content Flagging

## Parameters
- `post_id` (path, required, string) - The ID of the post to be removed

## Request body
No request body.

## Responses
- `200`: Post removed successfully
  - `application/json` -> StatusOK
- `403`: Forbidden - User does not have permission to remove this post.
- `404`: Post not found or feature is disabled via the feature flag.
- `500`: Internal server error.
- `501`: Feature is disabled either via config or an Enterprise Advanced license is not available.
