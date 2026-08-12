# Get a custom emoji

Original OpenAPI operationId: `GetEmoji`
- Method: `GET`
- Path: `/api/v4/emoji/{emoji_id}`
- Summary: Get a custom emoji
- Description: Get some metadata for a custom emoji.
##### Permissions
Must be authenticated.

- Tags: emoji

## Parameters
- `emoji_id` (path, required, string) - Emoji GUID

## Request body
No request body.

## Responses
- `200`: Emoji retrieval successful
  - `application/json` -> Emoji
- `400`: No description available.
- `401`: No description available.
- `404`: No description available.
- `501`: No description available.
