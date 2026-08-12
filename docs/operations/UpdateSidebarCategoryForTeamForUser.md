# Update sidebar category

Original OpenAPI operationId: `UpdateSidebarCategoryForTeamForUser`
- Method: `PUT`
- Path: `/api/v4/users/{user_id}/teams/{team_id}/channels/categories/{category_id}`
- Summary: Update sidebar category
- Description: Updates a single sidebar category for the user on the given team.
__Minimum server version__: 5.26
##### Permissions
Must be authenticated and have the `list_team_channels` permission.

- Tags: channels

## Parameters
- `team_id` (path, required, string) - Team GUID
- `user_id` (path, required, string) - User GUID
- `category_id` (path, required, string) - Category GUID

## Request body
- required: True
- content:
  - `application/json` -> SidebarCategory

## Responses
- `200`: Category update successful
  - `application/json` -> SidebarCategory
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
