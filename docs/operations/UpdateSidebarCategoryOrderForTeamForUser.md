# Update user's sidebar category order

Original OpenAPI operationId: `UpdateSidebarCategoryOrderForTeamForUser`
- Method: `PUT`
- Path: `/api/v4/users/{user_id}/teams/{team_id}/channels/categories/order`
- Summary: Update user's sidebar category order
- Description: Updates the order of the sidebar categories for a user on the given team. The provided array must include the IDs of all categories on the team.
__Minimum server version__: 5.26
##### Permissions
Must be authenticated and have the `list_team_channels` permission.

- Tags: channels

## Parameters
- `team_id` (path, required, string) - Team GUID
- `user_id` (path, required, string) - User GUID

## Request body
- required: True
- content:
  - `application/json` -> array of string

## Responses
- `200`: Order update successful
  - `application/json` -> array of string
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
