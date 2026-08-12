# Remove the team icon

Original OpenAPI operationId: `RemoveTeamIcon`
- Method: `DELETE`
- Path: `/api/v4/teams/{team_id}/image`
- Summary: Remove the team icon
- Description: Remove the team icon for the team.

__Minimum server version__: 4.10

##### Permissions
Must be authenticated and have the `manage_team` permission.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID

## Request body
No request body.

## Responses
- `200`: Team icon successfully remove
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
