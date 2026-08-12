# List commands for a team

Original OpenAPI operationId: `ListCommands`
- Method: `GET`
- Path: `/api/v4/commands`
- Summary: List commands for a team
- Description: List commands for a team.
##### Permissions
`manage_slash_commands` if need list custom commands.

- Tags: commands

## Parameters
- `team_id` (query, optional, string) - The team id.
- `custom_only` (query, optional, boolean) - To get only the custom commands. If set to false will get the custom
if the user have access plus the system commands, otherwise just the system commands.


## Request body
No request body.

## Responses
- `200`: List Commands retrieve successful
  - `application/json` -> array of Command
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
