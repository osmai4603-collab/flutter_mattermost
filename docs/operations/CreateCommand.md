# Create a command

Original OpenAPI operationId: `CreateCommand`
- Method: `POST`
- Path: `/api/v4/commands`
- Summary: Create a command
- Description: Create a command for a team.
##### Permissions
`manage_slash_commands` for the team the command is in.

- Tags: commands

## Parameters
No parameters.

## Request body
- required: True
- description: command to be created
- content:
  - `application/json` -> object

## Responses
- `201`: Command creation successful
  - `application/json` -> Command
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
