# Search channels

Original OpenAPI operationId: `SearchChannels`
- Method: `POST`
- Path: `/api/v4/teams/{team_id}/channels/search`
- Summary: Search channels
- Description: Search public channels on a team based on the search term provided in the request body.
##### Permissions
Must have the `list_team_channels` permission.

In server version 5.16 and later, a user without the `list_team_channels` permission will be able to use this endpoint, with the search results limited to the channels that the user is a member of.

- Tags: channels

## Parameters
- `team_id` (path, required, string) - Team GUID

## Request body
- required: True
- description: Search criteria
- content:
  - `application/json` -> object

## Responses
- `201`: Channels search successful
  - `application/json` -> array of Channel
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
