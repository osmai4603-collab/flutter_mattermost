# Get a list of paged and sorted users for admin reporting purposes

Original OpenAPI operationId: `GetUsersForReporting`
- Method: `GET`
- Path: `/api/v4/reports/users`
- Summary: Get a list of paged and sorted users for admin reporting purposes
- Description: Get a list of paged users for admin reporting purposes, based on provided parameters.
##### Permissions
Requires `sysconsole_read_user_management_users`.

- Tags: reports

## Parameters
- `sort_column` (query, optional, string) - The column to sort the users by. Must be one of ("CreateAt", "Username", "FirstName", "LastName", "Nickname", "Email") or the API will return an error.
- `direction` (query, optional, string) - The direction to accept paging values from. Will return values ahead of the cursor if "prev", and below the cursor if "next". Default is "next".
- `sort_direction` (query, optional, string) - The sorting direction. Must be one of ("asc", "desc"). Will default to 'asc' if not specified or the input is invalid.
- `page_size` (query, optional, integer) - The maximum number of users to return.
- `from_column_value` (query, optional, string) - The value of the sorted column corresponding to the cursor to read from. Should be blank for the first page asked for.
- `from_id` (query, optional, string) - The value of the user id corresponding to the cursor to read from. Should be blank for the first page asked for.
- `date_range` (query, optional, string) - The date range of the post statistics to display. Must be one of ("last30days", "previousmonth", "last6months", "alltime"). Will default to 'alltime' if the input is not valid.
- `role_filter` (query, optional, string) - Filter users by their role.
- `team_filter` (query, optional, string) - Filter users by a specified team ID.
- `has_no_team` (query, optional, boolean) - If true, show only users that have no team. Will ignore provided "team_filter" if true.
- `hide_active` (query, optional, boolean) - If true, show only users that are inactive. Cannot be used at the same time as "hide_inactive"
- `hide_inactive` (query, optional, boolean) - If true, show only users that are active. Cannot be used at the same time as "hide_active"
- `search_term` (query, optional, string) - A filtering search term that allows filtering by Username, FirstName, LastName, Nickname or Email

## Request body
No request body.

## Responses
- `200`: User page retrieval successful
  - `application/json` -> array of UserReport
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
