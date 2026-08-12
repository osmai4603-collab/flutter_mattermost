# Get post edit history

Original OpenAPI operationId: `GetEditHistoryForPost`
- Method: `GET`
- Path: `/api/v4/posts/{post_id}/edit_history`
- Summary: Get post edit history
- Description: Get edit history entries for a post.
##### Permissions
Must have `edit_post` permission in the channel. For most posts, only the original author can access history.

- Tags: posts

## Parameters
- `post_id` (path, required, string) - Post ID

## Request body
No request body.

## Responses
- `200`: Edit history retrieval successful
  - `application/json` -> array of Post
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
