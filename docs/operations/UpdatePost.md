# Update a post

Original OpenAPI operationId: `UpdatePost`
- Method: `PUT`
- Path: `/api/v4/posts/{post_id}`
- Summary: Update a post
- Description: Update a post. Only the fields listed below are updatable, omitted fields will be treated as blank.
##### Permissions
Must have `edit_post` permission for the channel the post is in.

- Tags: posts

## Parameters
- `post_id` (path, required, string) - ID of the post to update

## Request body
- required: True
- description: Post object that is to be updated
- content:
  - `application/json` -> object

## Responses
- `200`: Post update successful
  - `application/json` -> Post
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
