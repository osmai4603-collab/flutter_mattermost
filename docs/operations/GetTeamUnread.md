# Get unreads for a team

Original OpenAPI operationId: `GetTeamUnread`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/teams/{team_id}/unread`
- Summary: Get unreads for a team
- Description: Get the unread mention and message counts for a team for the specified user.
##### Permissions
Must be the user or have `edit_other_users` permission and have `view_team` permission for the team.

- Tags: teams

## Parameters
- `user_id` (path, required, string) - User GUID
- `team_id` (path, required, string) - Team GUID

## Request body
No request body.

## Responses
- `200`: Team unread count retrieval successful
  - `application/json` -> TeamUnread
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
