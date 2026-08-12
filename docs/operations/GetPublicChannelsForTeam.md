# Get public channels

Original OpenAPI operationId: `GetPublicChannelsForTeam`
- Method: `GET`
- Path: `/api/v4/teams/{team_id}/channels`
- Summary: Get public channels
- Description: Get a page of public channels on a team based on query string parameters - page and per_page.
##### Permissions
Must be authenticated and have the `list_team_channels` permission.

- Tags: channels

## Parameters
- `team_id` (path, required, string) - Team GUID
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of public channels per page.

## Request body
No request body.

## Responses
- `200`: Channels retrieval successful
  - `application/json` -> array of Channel
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
