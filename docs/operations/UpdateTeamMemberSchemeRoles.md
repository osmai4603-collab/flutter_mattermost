# Update the scheme-derived roles of a team member.

Original OpenAPI operationId: `UpdateTeamMemberSchemeRoles`
- Method: `PUT`
- Path: `/api/v4/teams/{team_id}/members/{user_id}/schemeRoles`
- Summary: Update the scheme-derived roles of a team member.
- Description: Update a team member's scheme_admin/scheme_user properties. Typically this should either be `scheme_admin=false, scheme_user=true` for ordinary team member, or `scheme_admin=true, scheme_user=true` for a team admin.

__Minimum server version__: 5.0

##### Permissions
Must be authenticated and have the `manage_team_roles` permission.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID
- `user_id` (path, required, string) - User GUID

## Request body
- required: True
- description: Scheme properties.
- content:
  - `application/json` -> object

## Responses
- `200`: Team member's scheme-derived roles updated successfully.
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
