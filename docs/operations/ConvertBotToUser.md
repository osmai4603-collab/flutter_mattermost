# Convert a bot into a user

Original OpenAPI operationId: `ConvertBotToUser`
- Method: `POST`
- Path: `/api/v4/bots/{bot_user_id}/convert_to_user`
- Summary: Convert a bot into a user
- Description: Convert a bot into a user.

__Minimum server version__: 5.26

##### Permissions
Must have `manage_system` permission.

- Tags: bots, users

## Parameters
- `bot_user_id` (path, required, string) - Bot user ID
- `set_system_admin` (query, optional, boolean) - Whether to give the user the system admin role.

## Request body
- required: True
- description: Data to be used in the user creation
- content:
  - `application/json` -> object

## Responses
- `200`: Bot successfully converted
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
