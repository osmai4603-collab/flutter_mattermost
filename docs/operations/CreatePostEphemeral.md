# Create a ephemeral post

Original OpenAPI operationId: `CreatePostEphemeral`
- Method: `POST`
- Path: `/api/v4/posts/ephemeral`
- Summary: Create a ephemeral post
- Description: Create a new ephemeral post in a channel.
##### Permissions
Must have `create_post_ephemeral` permission (currently only given to system admin)

- Tags: posts

## Parameters
No parameters.

## Request body
- required: True
- description: Ephemeral Post object to send
- content:
  - `application/json` -> object

## Responses
- `201`: Post creation successful
  - `application/json` -> Post
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
