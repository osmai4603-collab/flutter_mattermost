# Gets the full count of users that match the filter.

Original OpenAPI operationId: `GetUserCountForReporting`
- Method: `GET`
- Path: `/api/v4/reports/users/count`
- Summary: Gets the full count of users that match the filter.
- Description: Get the full count of users admin reporting purposes, based on provided parameters.
##### Permissions
Requires `sysconsole_read_user_management_users`.

- Tags: reports

## Parameters
- `role_filter` (query, optional, string) - Filter users by their role.
- `team_filter` (query, optional, string) - Filter users by a specified team ID.
- `has_no_team` (query, optional, boolean) - If true, show only users that have no team. Will ignore provided "team_filter" if true.
- `hide_active` (query, optional, boolean) - If true, show only users that are inactive. Cannot be used at the same time as "hide_inactive"
- `hide_inactive` (query, optional, boolean) - If true, show only users that are active. Cannot be used at the same time as "hide_active"
- `search_term` (query, optional, string) - A filtering search term that allows filtering by Username, FirstName, LastName, Nickname or Email

## Request body
No request body.

## Responses
- `200`: User count retrieval successful
  - `application/json` -> number
