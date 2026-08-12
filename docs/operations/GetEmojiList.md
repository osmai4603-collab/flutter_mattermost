# Get a list of custom emoji

Original OpenAPI operationId: `GetEmojiList`
- Method: `GET`
- Path: `/api/v4/emoji`
- Summary: Get a list of custom emoji
- Description: Get a page of metadata for custom emoji on the system. Since server version 4.7, sort using the `sort` query parameter.
##### Permissions
Must be authenticated.

- Tags: emoji

## Parameters
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of emojis per page.
- `sort` (query, optional, string) - Either blank for no sorting or "name" to sort by emoji names. Minimum server version for sorting is 4.7.

## Request body
No request body.

## Responses
- `200`: Emoji list retrieval successful
  - `application/json` -> Emoji
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
