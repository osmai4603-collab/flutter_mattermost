# Remove a reaction from a post

Original OpenAPI operationId: `DeleteReaction`
- Method: `DELETE`
- Path: `/api/v4/users/{user_id}/posts/{post_id}/reactions/{emoji_name}`
- Summary: Remove a reaction from a post
- Description: Deletes a reaction made by a user from the given post.
##### Permissions
Must be user or have `manage_system` permission.

- Tags: reactions

## Parameters
- `user_id` (path, required, string) - ID of the user
- `post_id` (path, required, string) - ID of the post
- `emoji_name` (path, required, string) - emoji name

## Request body
No request body.

## Responses
- `200`: Reaction deletion successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
