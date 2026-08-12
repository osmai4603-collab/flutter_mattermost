# Get a list of channels by ids

Original OpenAPI operationId: `GetPublicChannelsByIdsForTeam`
- Method: `POST`
- Path: `/api/v4/teams/{team_id}/channels/ids`
- Summary: Get a list of channels by ids
- Description: Get a list of public channels on a team by id.
##### Permissions
`view_team` for the team the channels are on.

- Tags: channels

## Parameters
- `team_id` (path, required, string) - Team GUID

## Request body
- required: True
- description: List of channel ids.
- content:
  - `application/json` -> array of string

## Responses
- `200`: Channel list retrieval successful
  - `application/json` -> array of Channel
- `400`: No description available.
- `401`: No description available.
- `404`: No description available.
