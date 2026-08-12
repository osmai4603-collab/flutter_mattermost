# Get all shared channels for team.

Original OpenAPI operationId: `GetAllSharedChannels`
- Method: `GET`
- Path: `/api/v4/sharedchannels/{team_id}`
- Summary: Get all shared channels for team.
- Description: Get all shared channels for a team.

__Minimum server version__: 5.50

##### Permissions
Must be authenticated and have the `view_team` permission for the team.
Results are restricted to channels the user is a member of unless the user has
`manage_shared_channels`.

- Tags: shared channels

## Parameters
- `team_id` (path, required, string) - Team Id
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of sharedchannels per page.

## Request body
No request body.

## Responses
- `200`: Shared channels fetch successful. Result may be empty.
  - `application/json` -> array of SharedChannel
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
