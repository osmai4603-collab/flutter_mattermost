# Update a command

Original OpenAPI operationId: `UpdateCommand`
- Method: `PUT`
- Path: `/api/v4/commands/{command_id}`
- Summary: Update a command
- Description: Update a single command based on command id string and Command struct.
##### Permissions
Must have `manage_slash_commands` permission for the team the command is in.

- Tags: commands

## Parameters
- `command_id` (path, required, string) - ID of the command to update

## Request body
- required: True
- content:
  - `application/json` -> Command

## Responses
- `200`: Command updated successful
  - `application/json` -> Command
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
