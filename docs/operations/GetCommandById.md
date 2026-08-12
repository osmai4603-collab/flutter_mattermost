# Get a command

Original OpenAPI operationId: `GetCommandById`
- Method: `GET`
- Path: `/api/v4/commands/{command_id}`
- Summary: Get a command
- Description: Get a command definition based on command id string.
##### Permissions
Must have `manage_slash_commands` permission for the team the command is in.

__Minimum server version__: 5.22

- Tags: commands

## Parameters
- `command_id` (path, required, string) - ID of the command to get

## Request body
No request body.

## Responses
- `200`: Command get successful
  - `application/json` -> Command
- `400`: No description available.
- `401`: No description available.
- `404`: No description available.
