# Update teams's privacy

Original OpenAPI operationId: `UpdateTeamPrivacy`
- Method: `PUT`
- Path: `/api/v4/teams/{team_id}/privacy`
- Summary: Update teams's privacy
- Description: Updates team's privacy allowing changing a team from Public (open) to Private (invitation only) and back.

__Minimum server version__: 5.24

##### Permissions
`manage_team` permission for the team of the team.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Team conversion successful
  - `application/json` -> Team
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
