# Get a bot

Original OpenAPI operationId: `GetBot`
- Method: `GET`
- Path: `/api/v4/bots/{bot_user_id}`
- Summary: Get a bot
- Description: Get a bot specified by its bot id.
##### Permissions
Must have `read_bots` permission for bots you are managing, and `read_others_bots` permission for bots others are managing.
__Minimum server version__: 5.10

- Tags: bots

## Parameters
- `bot_user_id` (path, required, string) - Bot user ID
- `include_deleted` (query, optional, boolean) - If deleted bots should be returned.

## Request body
No request body.

## Responses
- `200`: Bot successfully retrieved.
  - `application/json` -> Bot
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
