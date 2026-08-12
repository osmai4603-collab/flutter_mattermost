# Get team members by ids

Original OpenAPI operationId: `GetTeamMembersByIds`
- Method: `POST`
- Path: `/api/v4/teams/{team_id}/members/ids`
- Summary: Get team members by ids
- Description: Get a list of team members based on a provided array of user ids.
##### Permissions
Must have `view_team` permission for the team.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID

## Request body
- required: True
- description: List of user ids
- content:
  - `application/json` -> array of string

## Responses
- `200`: Team members retrieval successful
  - `application/json` -> array of TeamMember
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
