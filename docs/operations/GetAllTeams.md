# Get teams

Original OpenAPI operationId: `GetAllTeams`
- Method: `GET`
- Path: `/api/v4/teams`
- Summary: Get teams
- Description: For regular users only returns open teams. Users with the "manage_system" permission will return teams regardless of type. The result is based on query string parameters - page and per_page.
##### Permissions
Must be authenticated. "manage_system" permission is required to show all teams.

- Tags: teams

## Parameters
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of teams per page.
- `include_total_count` (query, optional, boolean) - Appends a total count of returned teams inside the response object - ex: `{ "teams": [], "total_count" : 0 }`.      
- `exclude_policy_constrained` (query, optional, boolean) - If set to true, teams which are part of a data retention policy will be excluded. The `sysconsole_read_compliance` permission is required to use this parameter.
__Minimum server version__: 5.35

## Request body
No request body.

## Responses
- `200`: Team list retrieval successful
  - `application/json` -> array of Team
- `400`: No description available.
- `401`: No description available.
