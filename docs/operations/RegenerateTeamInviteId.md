# Regenerate the Invite ID from a Team

Original OpenAPI operationId: `RegenerateTeamInviteId`
- Method: `POST`
- Path: `/api/v4/teams/{team_id}/regenerate_invite_id`
- Summary: Regenerate the Invite ID from a Team
- Description: Regenerates the invite ID used in invite links of a team
##### Permissions
Must be authenticated and have the `manage_team` permission.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID

## Request body
No request body.

## Responses
- `200`: Team Invite ID regenerated
  - `application/json` -> Team
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
