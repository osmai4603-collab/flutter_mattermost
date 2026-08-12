# List commands' autocomplete data

Original OpenAPI operationId: `ListCommandAutocompleteSuggestions`
- Method: `GET`
- Path: `/api/v4/teams/{team_id}/commands/autocomplete_suggestions`
- Summary: List commands' autocomplete data
- Description: List commands' autocomplete data for the team.
##### Permissions
`view_team` for the team.
__Minimum server version__: 5.24

- Tags: commands

## Parameters
- `team_id` (path, required, string) - Team GUID
- `user_input` (query, required, string) - String inputted by the user.

## Request body
No request body.

## Responses
- `200`: Commands' autocomplete data retrieval successful
  - `application/json` -> array of AutocompleteSuggestion
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
