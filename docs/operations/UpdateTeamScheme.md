# Set a team's scheme

Original OpenAPI operationId: `UpdateTeamScheme`
- Method: `PUT`
- Path: `/api/v4/teams/{team_id}/scheme`
- Summary: Set a team's scheme
- Description: Set a team's scheme, more specifically sets the scheme_id value of a team record.

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 5.0

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID

## Request body
- required: True
- description: Scheme GUID
- content:
  - `application/json` -> object

## Responses
- `200`: Update team scheme successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
