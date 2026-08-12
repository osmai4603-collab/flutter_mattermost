# Get custom emoji image

Original OpenAPI operationId: `GetEmojiImage`
- Method: `GET`
- Path: `/api/v4/emoji/{emoji_id}/image`
- Summary: Get custom emoji image
- Description: Get the image for a custom emoji.
##### Permissions
Must be authenticated.

- Tags: emoji

## Parameters
- `emoji_id` (path, required, string) - Emoji GUID

## Request body
No request body.

## Responses
- `200`: Emoji image retrieval successful
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `500`: No description available.
- `501`: No description available.
