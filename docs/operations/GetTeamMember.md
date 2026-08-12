# Get a team member

Original OpenAPI operationId: `GetTeamMember`
- Method: `GET`
- Path: `/api/v4/teams/{team_id}/members/{user_id}`
- Summary: Get a team member
- Description: Get a team member on the system.
##### Permissions
Must be authenticated and have the `view_team` permission.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID
- `user_id` (path, required, string) - User GUID

## Request body
No request body.

## Responses
- `200`: Team member retrieval successful
  - `application/json` -> TeamMember
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
