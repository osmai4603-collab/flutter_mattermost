# Check if team exists

Original OpenAPI operationId: `TeamExists`
- Method: `GET`
- Path: `/api/v4/teams/name/{team_name}/exists`
- Summary: Check if team exists
- Description: Check if the team exists based on a team name.
##### Permissions
Must be authenticated.

- Tags: teams

## Parameters
- `team_name` (path, required, string) - Team Name

## Request body
No request body.

## Responses
- `200`: Team retrieval successful
  - `application/json` -> TeamExists
- `400`: No description available.
- `401`: No description available.
- `404`: No description available.
