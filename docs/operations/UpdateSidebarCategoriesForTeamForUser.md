# Update user's sidebar categories

Original OpenAPI operationId: `UpdateSidebarCategoriesForTeamForUser`
- Method: `PUT`
- Path: `/api/v4/users/{user_id}/teams/{team_id}/channels/categories`
- Summary: Update user's sidebar categories
- Description: Update any number of sidebar categories for the user on the given team. This can be used to reorder the channels in these categories.
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
  - `application/json` -> array of SidebarCategory

## Responses
- `200`: Category update successful
  - `application/json` -> SidebarCategory
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
