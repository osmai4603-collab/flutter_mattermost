# Create a post

Original OpenAPI operationId: `CreatePost`
- Method: `POST`
- Path: `/api/v4/posts`
- Summary: Create a post
- Description: Create a new post in a channel. To create the post as a comment on another post, provide `root_id`.
##### Permissions
Must have `create_post` permission for the channel the post is being created in.

- Tags: posts

## Parameters
- `set_online` (query, optional, boolean) - Whether to set the user status as online or not.
- `silent` (query, optional, boolean) - When `true`, the post is delivered silently: visible in the channel and broadcast over WebSocket, but produces no desktop/push/email notifications, no unread or mention count increments, and no "New Messages" line. Only bot accounts, OAuth apps, incoming webhooks, and plugins may set this; non-integration senders receive HTTP 403. `force_notification` overrides `silent`.


## Request body
- required: True
- description: Post object to create
- content:
  - `application/json` -> object

## Responses
- `201`: Post creation successful
  - `application/json` -> Post
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
