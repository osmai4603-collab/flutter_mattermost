# Remove user from team

Original OpenAPI operationId: `RemoveTeamMember`
- Method: `DELETE`
- Path: `/api/v4/teams/{team_id}/members/{user_id}`
- Summary: Remove user from team
- Description: Delete the team member object for a user, effectively removing them from a team.
##### Permissions
Must be logged in as the user or have the `remove_user_from_team` permission.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID
- `user_id` (path, required, string) - User GUID

## Request body
No request body.

## Responses
- `200`: Team member deletion successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
