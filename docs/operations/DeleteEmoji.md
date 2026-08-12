# Delete a custom emoji

Original OpenAPI operationId: `DeleteEmoji`
- Method: `DELETE`
- Path: `/api/v4/emoji/{emoji_id}`
- Summary: Delete a custom emoji
- Description: Delete a custom emoji.
##### Permissions
Must have the `manage_team` or `manage_system` permissions or be the user who created the emoji.

- Tags: emoji

## Parameters
- `emoji_id` (path, required, string) - Emoji GUID

## Request body
No request body.

## Responses
- `200`: Emoji delete successful
  - `application/json` -> Emoji
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
