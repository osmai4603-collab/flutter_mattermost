# Move a command

Original OpenAPI operationId: `MoveCommand`
- Method: `PUT`
- Path: `/api/v4/commands/{command_id}/move`
- Summary: Move a command
- Description: Move a command to a different team based on command id string.
##### Permissions
Must have `manage_slash_commands` permission for the team the command is currently in and the destination team.

__Minimum server version__: 5.22

- Tags: commands

## Parameters
- `command_id` (path, required, string) - ID of the command to move

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Command move successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
