# Search custom emoji

Original OpenAPI operationId: `SearchEmoji`
- Method: `POST`
- Path: `/api/v4/emoji/search`
- Summary: Search custom emoji
- Description: Search for custom emoji by name based on search criteria provided in the request body. A maximum of 200 results are returned.
##### Permissions
Must be authenticated.

__Minimum server version__: 4.7

- Tags: emoji

## Parameters
No parameters.

## Request body
- required: True
- description: Search criteria
- content:
  - `application/json` -> object

## Responses
- `200`: Emoji list retrieval successful
  - `application/json` -> array of Emoji
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
