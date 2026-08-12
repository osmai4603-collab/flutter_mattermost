# Update a team member roles

Original OpenAPI operationId: `UpdateTeamMemberRoles`
- Method: `PUT`
- Path: `/api/v4/teams/{team_id}/members/{user_id}/roles`
- Summary: Update a team member roles
- Description: Update a team member roles. Valid team roles are "team_user", "team_admin" or both of them. Overwrites any previously assigned team roles.
##### Permissions
Must be authenticated and have the `manage_team_roles` permission.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID
- `user_id` (path, required, string) - User GUID

## Request body
- required: True
- description: Space-delimited team roles to assign to the user
- content:
  - `application/json` -> object

## Responses
- `200`: Team member roles update successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
