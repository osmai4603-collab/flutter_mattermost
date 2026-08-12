# Add user to team from invite

Original OpenAPI operationId: `AddTeamMemberFromInvite`
- Method: `POST`
- Path: `/api/v4/teams/members/invite`
- Summary: Add user to team from invite
- Description: Using either an invite id or hash/data pair from an email invite link, add a user to a team.
##### Permissions
Must be authenticated.

- Tags: teams

## Parameters
- `token` (query, required, string) - Token id from the invitation

## Request body
No request body.

## Responses
- `201`: Team member creation successful
  - `application/json` -> TeamMember
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
