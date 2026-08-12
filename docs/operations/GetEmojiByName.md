# Get a custom emoji by name

Original OpenAPI operationId: `GetEmojiByName`
- Method: `GET`
- Path: `/api/v4/emoji/name/{emoji_name}`
- Summary: Get a custom emoji by name
- Description: Get some metadata for a custom emoji using its name.
##### Permissions
Must be authenticated.

__Minimum server version__: 4.7

- Tags: emoji

## Parameters
- `emoji_name` (path, required, string) - Emoji name

## Request body
No request body.

## Responses
- `200`: Emoji retrieval successful
  - `application/json` -> Emoji
- `400`: No description available.
- `401`: No description available.
- `404`: No description available.
- `501`: No description available.
