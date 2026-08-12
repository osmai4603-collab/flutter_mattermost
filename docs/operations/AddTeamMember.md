# Add user to team

Original OpenAPI operationId: `AddTeamMember`
- Method: `POST`
- Path: `/api/v4/teams/{team_id}/members`
- Summary: Add user to team
- Description: Add user to the team by user_id.
##### Permissions
Must be authenticated and team be open to add self. For adding another user, authenticated user must have the `add_user_to_team` permission.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `201`: Team member creation successful
  - `application/json` -> TeamMember
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
