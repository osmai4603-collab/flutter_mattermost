# Get the access control policy for a team

Original OpenAPI operationId: `GetTeamAccessControlPolicy`
- Method: `GET`
- Path: `/api/v4/teams/{team_id}/access_control/policy`
- Summary: Get the access control policy for a team
- Description: Get the attribute-based access control policy assigned to a team, along
with whether the team currently enforces a membership policy. `policy` is
null when no policy is assigned or attribute-based access control is not
available on the server.
##### Permissions
Must have the `manage_system` permission or the `manage_team_access_rules`
permission for the team.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID

## Request body
No request body.

## Responses
- `200`: Team access control policy retrieval successful
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
