# Set a post reminder

Original OpenAPI operationId: `SetPostReminder`
- Method: `POST`
- Path: `/api/v4/users/{user_id}/posts/{post_id}/reminder`
- Summary: Set a post reminder
- Description: Set a reminder for the user for the post.
##### Permissions
Must have `read_channel` permission for the channel the post is in.

__Minimum server version__: 7.2

- Tags: posts

## Parameters
- `user_id` (path, required, string) - User GUID
- `post_id` (path, required, string) - Post GUID

## Request body
- required: True
- description: Target time for the reminder
- content:
  - `application/json` -> object

## Responses
- `200`: Reminder set successfully
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
