# Get a list of reactions to a post

Original OpenAPI operationId: `GetReactions`
- Method: `GET`
- Path: `/api/v4/posts/{post_id}/reactions`
- Summary: Get a list of reactions to a post
- Description: Get a list of reactions made by all users to a given post.
##### Permissions
Must have `read_channel` permission for the channel the post is in.

- Tags: reactions

## Parameters
- `post_id` (path, required, string) - ID of a post

## Request body
No request body.

## Responses
- `200`: List reactions retrieve successful
  - `application/json` -> array of Reaction
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
