# Delete a command

Original OpenAPI operationId: `DeleteCommand`
- Method: `DELETE`
- Path: `/api/v4/commands/{command_id}`
- Summary: Delete a command
- Description: Delete a command based on command id string.
##### Permissions
Must have `manage_slash_commands` permission for the team the command is in.

- Tags: commands

## Parameters
- `command_id` (path, required, string) - ID of the command to delete

## Request body
No request body.

## Responses
- `200`: Command deletion successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
