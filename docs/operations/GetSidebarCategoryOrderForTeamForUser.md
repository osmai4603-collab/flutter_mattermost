# Get user's sidebar category order

Original OpenAPI operationId: `GetSidebarCategoryOrderForTeamForUser`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/teams/{team_id}/channels/categories/order`
- Summary: Get user's sidebar category order
- Description: Returns the order of the sidebar categories for a user on the given team as an array of IDs.
__Minimum server version__: 5.26
##### Permissions
Must be authenticated and have the `list_team_channels` permission.

- Tags: channels

## Parameters
- `team_id` (path, required, string) - Team GUID
- `user_id` (path, required, string) - User GUID

## Request body
No request body.

## Responses
- `200`: Order retrieval successful
  - `application/json` -> array of string
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
