# Get user's sidebar categories

Original OpenAPI operationId: `GetSidebarCategoriesForTeamForUser`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/teams/{team_id}/channels/categories`
- Summary: Get user's sidebar categories
- Description: Get a list of sidebar categories that will appear in the user's sidebar on the given team, including a list of channel IDs in each category.
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
- `200`: Category retrieval successful
  - `application/json` -> array of OrderedSidebarCategories
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
