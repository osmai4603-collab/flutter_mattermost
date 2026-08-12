# Get team members

Original OpenAPI operationId: `GetTeamMembers`
- Method: `GET`
- Path: `/api/v4/teams/{team_id}/members`
- Summary: Get team members
- Description: Get a page team members list based on query string parameters - team id, page and per page.
##### Permissions
Must be authenticated and have the `view_team` permission.

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of users per page.
- `sort` (query, optional, string) - To sort by Username, set to 'Username', otherwise sort is by 'UserID'
- `exclude_deleted_users` (query, optional, boolean) - Excludes deleted users from the results

## Request body
No request body.

## Responses
- `200`: Team members retrieval successful
  - `application/json` -> array of TeamMember
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
