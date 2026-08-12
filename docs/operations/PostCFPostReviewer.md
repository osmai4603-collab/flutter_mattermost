# Assign a content reviewer to a flagged post

Original OpenAPI operationId: `PostCFPostReviewer`
- Method: `POST`
- Path: `/api/v4/content_flagging/post/{post_id}/assign/{content_reviewer_id}`
- Summary: Assign a content reviewer to a flagged post
- Description: Assigns a content reviewer to a specific flagged post for review. The user must be a content reviewer of the team to which the post belongs to.
An enterprise advanced license is required.

- Tags: Content Flagging

## Parameters
- `post_id` (path, required, string) - The ID of the post to assign a content reviewer to
- `content_reviewer_id` (path, required, string) - The ID of the user to be assigned as the content reviewer for the post

## Request body
No request body.

## Responses
- `200`: Content reviewer assigned successfully
  - `application/json` -> StatusOK
- `400`: Bad request - Invalid input data or missing required fields.
- `403`: Forbidden - User does not have permission to assign a reviewer to this post.
- `404`: Post or user not found, or feature is disabled via the feature flag.
- `500`: Internal server error.
- `501`: Feature is disabled either via config or an Enterprise Advanced license is not available.
