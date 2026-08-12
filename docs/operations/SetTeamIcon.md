# Sets the team icon

Original OpenAPI operationId: `SetTeamIcon`
- Method: `POST`
- Path: `/api/v4/teams/{team_id}/image`
- Summary: Sets the team icon
- Description: Sets the team icon for the team.

__Minimum server version__: 4.9

##### Permissions
Must be authenticated and have the `manage_team` permission.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID

## Request body
- required: False
- content:
  - `multipart/form-data` -> object

## Responses
- `200`: Team icon successfully set
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
