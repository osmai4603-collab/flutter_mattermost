# Get private channels

Original OpenAPI operationId: `GetPrivateChannelsForTeam`
- Method: `GET`
- Path: `/api/v4/teams/{team_id}/channels/private`
- Summary: Get private channels
- Description: Get a page of private channels on a team based on query string
parameters - team_id, page and per_page.

__Minimum server version__: 5.26

##### Permissions
Must have `manage_system` permission.

- Tags: channels

## Parameters
- `team_id` (path, required, string) - Team GUID
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of private channels per page.

## Request body
No request body.

## Responses
- `200`: Channels retrieval successful
  - `application/json` -> array of Channel
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
