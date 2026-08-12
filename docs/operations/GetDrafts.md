# Get synced drafts for a team

Original OpenAPI operationId: `GetDrafts`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/teams/{team_id}/drafts`
- Summary: Get synced drafts for a team
- Description: Get synced drafts for the current user in a team.
##### Permissions
Must have `view_team` permission for the team and synced drafts must be enabled.

- Tags: users, drafts

## Parameters
- `user_id` (path, required, string) - User ID
- `team_id` (path, required, string) - Team ID

## Request body
No request body.

## Responses
- `200`: Drafts retrieval successful
  - `application/json` -> array of Draft
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
