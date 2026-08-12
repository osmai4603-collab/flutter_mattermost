# Keep a flagged post

Original OpenAPI operationId: `KeepCFPost`
- Method: `PUT`
- Path: `/api/v4/content_flagging/post/{post_id}/keep`
- Summary: Keep a flagged post
- Description: Marks a flagged post as reviewed and keeps it in the system without any changes. This action is typically performed by content reviewers after they have reviewed the flagged content and determined that it does not violate any guidelines.
The user must be a content reviewer of the team to which the post belongs to.
An enterprise advanced license is required.

- Tags: Content Flagging

## Parameters
- `post_id` (path, required, string) - The ID of the post to be kept

## Request body
No request body.

## Responses
- `200`: Post marked to be kept successfully
  - `application/json` -> StatusOK
- `403`: Forbidden - User does not have permission to keep this post.
- `404`: Post not found or feature is disabled via the feature flag.
- `500`: Internal server error.
- `501`: Feature is disabled either via config or an Enterprise Advanced license is not available.
