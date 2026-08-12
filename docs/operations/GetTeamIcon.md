# Get the team icon

Original OpenAPI operationId: `GetTeamIcon`
- Method: `GET`
- Path: `/api/v4/teams/{team_id}/image`
- Summary: Get the team icon
- Description: Get the team icon of the team.

__Minimum server version__: 4.9

##### Permissions
User must be authenticated. In addition, team must be open or the user must have the `view_team` permission.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID

## Request body
No request body.

## Responses
- `200`: Team icon retrieval successful
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
