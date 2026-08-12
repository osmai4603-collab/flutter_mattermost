# Delete synced thread draft

Original OpenAPI operationId: `DeleteDraftForThread`
- Method: `DELETE`
- Path: `/api/v4/users/{user_id}/channels/{channel_id}/drafts/{thread_id}`
- Summary: Delete synced thread draft
- Description: Delete a synced draft for a channel thread.
##### Permissions
Must be authenticated as the draft owner and synced drafts must be enabled.

- Tags: users, drafts

## Parameters
- `user_id` (path, required, string) - User ID
- `channel_id` (path, required, string) - Channel ID
- `thread_id` (path, required, string) - Root post ID of the thread

## Request body
No request body.

## Responses
- `200`: Thread draft deletion successful
  - `application/json` -> StatusOK
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
