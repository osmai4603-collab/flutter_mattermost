# Assign a bot to a user

Original OpenAPI operationId: `AssignBot`
- Method: `POST`
- Path: `/api/v4/bots/{bot_user_id}/assign/{user_id}`
- Summary: Assign a bot to a user
- Description: Assign a bot to a specified user.
##### Permissions
Must have `manage_bots` permission. 
__Minimum server version__: 5.10

- Tags: bots

## Parameters
- `bot_user_id` (path, required, string) - Bot user ID
- `user_id` (path, required, string) - The user ID to assign the bot to.

## Request body
No request body.

## Responses
- `200`: Bot successfully assigned.
  - `application/json` -> Bot
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
