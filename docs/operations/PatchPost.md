# Patch a post

Original OpenAPI operationId: `PatchPost`
- Method: `PUT`
- Path: `/api/v4/posts/{post_id}/patch`
- Summary: Patch a post
- Description: Partially update a post by providing only the fields you want to update. Omitted fields will not be updated. The fields that can be updated are defined in the request body, all other provided fields will be ignored.
##### Permissions
Must have the `edit_post` permission.

- Tags: posts

## Parameters
- `post_id` (path, required, string) - Post GUID

## Request body
- required: True
- description: Post object that is to be updated
- content:
  - `application/json` -> object

## Responses
- `200`: Post patch successful
  - `application/json` -> Post
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
