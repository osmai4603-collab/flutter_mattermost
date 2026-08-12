# Get a team stats

Original OpenAPI operationId: `GetTeamStats`
- Method: `GET`
- Path: `/api/v4/teams/{team_id}/stats`
- Summary: Get a team stats
- Description: Get a team stats on the system.
##### Permissions
Must be authenticated and have the `view_team` permission.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID

## Request body
No request body.

## Responses
- `200`: Team stats retrieval successful
  - `application/json` -> TeamStats
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
