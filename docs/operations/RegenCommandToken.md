# Generate a new token

Original OpenAPI operationId: `RegenCommandToken`
- Method: `PUT`
- Path: `/api/v4/commands/{command_id}/regen_token`
- Summary: Generate a new token
- Description: Generate a new token for the command based on command id string.
##### Permissions
Must have `manage_slash_commands` permission for the team the command is in.

- Tags: commands

## Parameters
- `command_id` (path, required, string) - ID of the command to generate the new token

## Request body
No request body.

## Responses
- `200`: Token generation successful
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
