# Create a custom emoji

Original OpenAPI operationId: `CreateEmoji`
- Method: `POST`
- Path: `/api/v4/emoji`
- Summary: Create a custom emoji
- Description: Create a custom emoji for the team.
##### Permissions
Must be authenticated.

- Tags: emoji

## Parameters
No parameters.

## Request body
- required: False
- content:
  - `multipart/form-data` -> object

## Responses
- `201`: Emoji creation successful
  - `application/json` -> Emoji
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `413`: No description available.
- `501`: No description available.
