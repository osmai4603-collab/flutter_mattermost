# Get team members for a user

Original OpenAPI operationId: `GetTeamMembersForUser`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/teams/members`
- Summary: Get team members for a user
- Description: Get a list of team members for a user. Useful for getting the ids of teams the user is on and the roles they have in those teams.
##### Permissions
Must be logged in as the user or have the `edit_other_users` permission.

- Tags: teams

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
No request body.

## Responses
- `200`: Team members retrieval successful
  - `application/json` -> array of TeamMember
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
