# Convert a user into a bot

Original OpenAPI operationId: `ConvertUserToBot`
- Method: `POST`
- Path: `/api/v4/users/{user_id}/convert_to_bot`
- Summary: Convert a user into a bot
- Description: Convert a user into a bot.

__Minimum server version__: 5.26

##### Permissions
Must have `manage_system` permission.

- Tags: bots, users

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
No request body.

## Responses
- `200`: User successfully converted
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
