# Delete a post

Original OpenAPI operationId: `DeletePost`
- Method: `DELETE`
- Path: `/api/v4/posts/{post_id}`
- Summary: Delete a post
- Description: Soft deletes a post, by marking the post as deleted in the database. Soft deleted posts will not be returned in post queries.
##### Permissions
Must be logged in as the user or have `delete_others_posts` permission.

- Tags: posts

## Parameters
- `post_id` (path, required, string) - ID of the post to delete

## Request body
No request body.

## Responses
- `200`: Post deletion successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
