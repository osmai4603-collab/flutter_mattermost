# Get content flagging property field values for a post

Original OpenAPI operationId: `GetCFPostFieldValues`
- Method: `GET`
- Path: `/api/v4/content_flagging/post/{post_id}/field_values`
- Summary: Get content flagging property field values for a post
- Description: Returns the property field values associated with content flagging reports for a specific post. These values provide additional context about the flags on the post.
An enterprise advanced license is required.

- Tags: Content Flagging

## Parameters
- `post_id` (path, required, string) - The ID of the post to retrieve property field values for

## Request body
No request body.

## Responses
- `200`: Property field values retrieved successfully
  - `application/json` -> array of PropertyValue
- `403`: Forbidden - User does not have permission to access this post.
- `404`: Post not found or feature is disabled via the feature flag.
- `500`: Internal server error.
- `501`: Feature is disabled either via config or an Enterprise Advanced license is not available.
