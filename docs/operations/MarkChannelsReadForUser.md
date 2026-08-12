# Mark multiple channels as read

Original OpenAPI operationId: `MarkChannelsReadForUser`
- Method: `POST`
- Path: `/api/v4/channels/members/{user_id}/mark_read`
- Summary: Mark multiple channels as read
- Description: Mark multiple channels as viewed for the given user.
##### Permissions
Must be logged in as the user or have `edit_other_users` permission.

- Tags: channels

## Parameters
- `user_id` (path, required, string) - User ID to mark channels read for

## Request body
- required: True
- content:
  - `application/json` -> array of string

## Responses
- `200`: Channels marked as read
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
