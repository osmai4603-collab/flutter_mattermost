# Add multiple users to team

Original OpenAPI operationId: `AddTeamMembers`
- Method: `POST`
- Path: `/api/v4/teams/{team_id}/members/batch`
- Summary: Add multiple users to team
- Description: Add a number of users to the team by user_id.
##### Permissions
Must be authenticated. Authenticated user must have the `add_user_to_team` permission.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID
- `graceful` (query, optional, boolean) - Instead of aborting the operation if a user cannot be added, return an arrray that will contain both the success and added members and the ones with error, in form of `[{"member": {...}, "user_id", "...", "error": {...}}]`

## Request body
- required: True
- content:
  - `application/json` -> array of TeamMember

## Responses
- `201`: Team members created successfully.
  - `application/json` -> array of TeamMember
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
