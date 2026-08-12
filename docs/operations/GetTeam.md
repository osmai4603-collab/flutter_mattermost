# Get a team

Original OpenAPI operationId: `GetTeam`
- Method: `GET`
- Path: `/api/v4/teams/{team_id}`
- Summary: Get a team
- Description: Get a team on the system.
##### Permissions
Must be authenticated and have the `view_team` permission.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID

## Request body
No request body.

## Responses
- `200`: Team retrieval successful
  - `application/json` -> Team
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
