# Create a bot

Original OpenAPI operationId: `CreateBot`
- Method: `POST`
- Path: `/api/v4/bots`
- Summary: Create a bot
- Description: Create a new bot account on the system. Username is required.
##### Permissions
Must have `create_bot` permission.
__Minimum server version__: 5.10

- Tags: bots

## Parameters
No parameters.

## Request body
- required: True
- description: Bot to be created
- content:
  - `application/json` -> object

## Responses
- `201`: Bot creation successful
  - `application/json` -> Bot
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
