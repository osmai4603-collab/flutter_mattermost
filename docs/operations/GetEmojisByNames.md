# Get custom emojis by name

Original OpenAPI operationId: `GetEmojisByNames`
- Method: `POST`
- Path: `/api/v4/emoji/names`
- Summary: Get custom emojis by name
- Description: Get a list of custom emoji based on a provided list of emoji names. A maximum of 200 results are returned.
##### Permissions
Must be authenticated.
__Minimum server version__: 9.2

- Tags: emoji

## Parameters
No parameters.

## Request body
- required: True
- description: List of emoji names
- content:
  - `application/json` -> array of string

## Responses
- `200`: Emoji list retrieval successful
  - `application/json` -> array of User
- `400`: No description available.
- `401`: No description available.
- `501`: No description available.
