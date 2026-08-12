# Patch a team

Original OpenAPI operationId: `PatchTeam`
- Method: `PUT`
- Path: `/api/v4/teams/{team_id}/patch`
- Summary: Patch a team
- Description: Partially update a team by providing only the fields you want to update. Omitted fields will not be updated. The fields that can be updated are defined in the request body, all other provided fields will be ignored.
##### Permissions
Must have the `manage_team` permission.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID

## Request body
- required: True
- description: Team object that is to be updated
- content:
  - `application/json` -> object

## Responses
- `200`: team patch successful
  - `application/json` -> Team
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
