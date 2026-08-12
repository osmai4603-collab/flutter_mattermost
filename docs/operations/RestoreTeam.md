# Restore a team

Original OpenAPI operationId: `RestoreTeam`
- Method: `POST`
- Path: `/api/v4/teams/{team_id}/restore`
- Summary: Restore a team
- Description: Restore a team that was previously soft deleted.

__Minimum server version__: 5.24

##### Permissions
Must have the `manage_team` permission.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID

## Request body
No request body.

## Responses
- `200`: Team restore successful
  - `application/json` -> Team
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
