# Get the access control attributes governing a team

Original OpenAPI operationId: `GetTeamAccessControlAttributes`
- Method: `GET`
- Path: `/api/v4/teams/{team_id}/access_control/attributes`
- Summary: Get the access control attributes governing a team
- Description: Get the attributes used by the team's membership access control policy,
as a map of attribute name to the values that satisfy the rule. This lets
membership surfaces explain the requirement to join the team. Values that
are source-only or shared-only are stripped, so no sensitive value is
disclosed. The map is empty when no membership policy governs the team.
##### Permissions
Must have the `view_team` permission for the team.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID

## Request body
No request body.

## Responses
- `200`: Team access control attributes retrieval successful
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
