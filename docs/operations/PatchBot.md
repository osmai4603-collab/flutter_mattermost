# Patch a bot

Original OpenAPI operationId: `PatchBot`
- Method: `PUT`
- Path: `/api/v4/bots/{bot_user_id}`
- Summary: Patch a bot
- Description: Partially update a bot by providing only the fields you want to update. Omitted fields will not be updated. The fields that can be updated are defined in the request body, all other provided fields will be ignored.
##### Permissions
Must have `manage_bots` permission. 
__Minimum server version__: 5.10

- Tags: bots

## Parameters
- `bot_user_id` (path, required, string) - Bot user ID

## Request body
- required: True
- description: Bot to be created
- content:
  - `application/json` -> object

## Responses
- `200`: Bot patch successful
  - `application/json` -> Bot
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
