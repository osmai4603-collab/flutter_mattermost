# Autocomplete channels

Original OpenAPI operationId: `AutocompleteChannelsForTeam`
- Method: `GET`
- Path: `/api/v4/teams/{team_id}/channels/autocomplete`
- Summary: Autocomplete channels
- Description: Autocomplete public channels on a team based on the search term provided in the request URL.

__Minimum server version__: 4.7

##### Permissions
Must have the `list_team_channels` permission.

- Tags: channels

## Parameters
- `team_id` (path, required, string) - Team GUID
- `name` (query, required, string) - Name or display name

## Request body
No request body.

## Responses
- `200`: Channels autocomplete successful
  - `application/json` -> array of Channel
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
