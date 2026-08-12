# Mark as unread from a post.

Original OpenAPI operationId: `SetPostUnread`
- Method: `POST`
- Path: `/api/v4/users/{user_id}/posts/{post_id}/set_unread`
- Summary: Mark as unread from a post.
- Description: Mark a channel as being unread from a given post.
##### Permissions
Must have `read_channel` permission for the channel the post is in or if the channel is public, have the `read_public_channels` permission for the team.
Must have `edit_other_users` permission if the user is not the one marking the post for himself.

__Minimum server version__: 5.18

- Tags: posts

## Parameters
- `user_id` (path, required, string) - User GUID
- `post_id` (path, required, string) - Post GUID

## Request body
No request body.

## Responses
- `200`: Post marked as unread successfully
  - `application/json` -> ChannelUnreadAt
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
