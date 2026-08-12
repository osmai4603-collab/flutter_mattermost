# Mark all direct and group messages as read

Original OpenAPI operationId: `MarkAllDirectMessagesRead`
- Method: `PUT`
- Path: `/api/v4/channels/members/{user_id}/direct/read`
- Summary: Mark all direct and group messages as read
- Description: Mark all direct and group messages as read for a user.

##### Permissions

Must be logged in as user or have `edit_other_users` permission.

__Minimum server version__: 11.3

- Tags: channels

## Parameters
- `user_id` (path, required, string) - User ID to mark messages as read for

## Request body
No request body.

## Responses
- `200`: Direct messages marked as read successfully
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
