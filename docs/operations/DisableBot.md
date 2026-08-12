# Disable a bot

Original OpenAPI operationId: `DisableBot`
- Method: `POST`
- Path: `/api/v4/bots/{bot_user_id}/disable`
- Summary: Disable a bot
- Description: Disable a bot.
##### Permissions
Must have `manage_bots` permission. 
__Minimum server version__: 5.10

- Tags: bots

## Parameters
- `bot_user_id` (path, required, string) - Bot user ID

## Request body
No request body.

## Responses
- `200`: Bot successfully disabled.
  - `application/json` -> Bot
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
