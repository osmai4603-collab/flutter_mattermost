# Get a team by name

Original OpenAPI operationId: `GetTeamByName`
- Method: `GET`
- Path: `/api/v4/teams/name/{team_name}`
- Summary: Get a team by name
- Description: Get a team based on provided name string
##### Permissions
Must be authenticated, team type is open and have the `view_team` permission.

- Tags: teams

## Parameters
- `team_name` (path, required, string) - Team Name

## Request body
No request body.

## Responses
- `200`: Team retrieval successful
  - `application/json` -> Team
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
