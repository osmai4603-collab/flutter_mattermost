# Execute a command

Original OpenAPI operationId: `ExecuteCommand`
- Method: `POST`
- Path: `/api/v4/commands/execute`
- Summary: Execute a command
- Description: Execute a command on a team.
##### Permissions
Must have `use_slash_commands` permission for the team the command is in.

- Tags: commands

## Parameters
No parameters.

## Request body
- required: True
- description: command to be executed
- content:
  - `application/json` -> object

## Responses
- `200`: Command execution successful
  - `application/json` -> CommandResponse
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
