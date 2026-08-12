# Autocomplete users

Original OpenAPI operationId: `AutocompleteUsers`
- Method: `GET`
- Path: `/api/v4/users/autocomplete`
- Summary: Autocomplete users
- Description: Get a list of users for the purpose of autocompleting based on the provided search term. Specify a combination of `team_id` and `channel_id` to filter results further.
##### Permissions
Requires an active session and `view_team` and `read_channel` on any teams or channels used to filter the results further.

- Tags: users

## Parameters
- `team_id` (query, optional, string) - Team ID
- `channel_id` (query, optional, string) - Channel ID
- `name` (query, required, string) - Username, nickname first name or last name
- `limit` (query, optional, integer) - The maximum number of users to return in each subresult

__Available as of server version 5.6. Defaults to `100` if not provided or on an earlier server version.__


## Request body
No request body.

## Responses
- `200`: User autocomplete successful
  - `application/json` -> UserAutocomplete
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
