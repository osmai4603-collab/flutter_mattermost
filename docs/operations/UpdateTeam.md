# Update a team

Original OpenAPI operationId: `UpdateTeam`
- Method: `PUT`
- Path: `/api/v4/teams/{team_id}`
- Summary: Update a team
- Description: Update a team by providing the team object. The fields that can be updated are defined in the request body, all other provided fields will be ignored.
##### Permissions
Must have the `manage_team` permission.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID

## Request body
- required: True
- description: Team to update
- content:
  - `application/json` -> object

## Responses
- `200`: Team update successful
  - `application/json` -> Team
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
