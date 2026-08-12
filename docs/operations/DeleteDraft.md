# Delete synced draft

Original OpenAPI operationId: `DeleteDraft`
- Method: `DELETE`
- Path: `/api/v4/users/{user_id}/channels/{channel_id}/drafts`
- Summary: Delete synced draft
- Description: Delete a synced draft for a channel.
##### Permissions
Must be authenticated as the draft owner and synced drafts must be enabled.

- Tags: users, drafts

## Parameters
- `user_id` (path, required, string) - User ID
- `channel_id` (path, required, string) - Channel ID

## Request body
No request body.

## Responses
- `200`: Draft deletion successful
  - `application/json` -> StatusOK
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
