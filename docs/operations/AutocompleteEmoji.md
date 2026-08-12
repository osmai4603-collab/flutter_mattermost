# Autocomplete custom emoji

Original OpenAPI operationId: `AutocompleteEmoji`
- Method: `GET`
- Path: `/api/v4/emoji/autocomplete`
- Summary: Autocomplete custom emoji
- Description: Get a list of custom emoji with names starting with or matching the provided name. Returns a maximum of 100 results.
##### Permissions
Must be authenticated.

__Minimum server version__: 4.7

- Tags: emoji

## Parameters
- `name` (query, required, string) - The emoji name to search.

## Request body
No request body.

## Responses
- `200`: Emoji list retrieval successful
  - `application/json` -> Emoji
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
