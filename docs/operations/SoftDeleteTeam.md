# Delete a team

Original OpenAPI operationId: `SoftDeleteTeam`
- Method: `DELETE`
- Path: `/api/v4/teams/{team_id}`
- Summary: Delete a team
- Description: Soft deletes a team, by marking the team as deleted in the database. Soft deleted teams will not be accessible in the user interface.

Optionally use the permanent query parameter to hard delete the team for compliance reasons. As of server version 5.0, to use this feature `ServiceSettings.EnableAPITeamDeletion` must be set to `true` in the server's configuration.
##### Permissions
Must have the `manage_team` permission.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID
- `permanent` (query, optional, boolean) - Permanently delete the team, to be used for compliance reasons only. As of server version 5.0, `ServiceSettings.EnableAPITeamDeletion` must be set to `true` in the server's configuration.

## Request body
No request body.

## Responses
- `200`: Team deletion successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
