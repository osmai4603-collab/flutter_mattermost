# Enable a bot

Original OpenAPI operationId: `EnableBot`
- Method: `POST`
- Path: `/api/v4/bots/{bot_user_id}/enable`
- Summary: Enable a bot
- Description: Enable a bot.
##### Permissions
Must have `manage_bots` permission. 
__Minimum server version__: 5.10

- Tags: bots

## Parameters
- `bot_user_id` (path, required, string) - Bot user ID

## Request body
No request body.

## Responses
- `200`: Bot successfully enabled.
  - `application/json` -> Bot
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
