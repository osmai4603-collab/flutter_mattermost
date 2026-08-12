# List autocomplete commands

Original OpenAPI operationId: `ListAutocompleteCommands`
- Method: `GET`
- Path: `/api/v4/teams/{team_id}/commands/autocomplete`
- Summary: List autocomplete commands
- Description: List autocomplete commands in the team.
##### Permissions
`view_team` for the team.

- Tags: commands

## Parameters
- `team_id` (path, required, string) - Team GUID

## Request body
No request body.

## Responses
- `200`: Autocomplete commands retrieval successful
  - `application/json` -> array of Command
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
