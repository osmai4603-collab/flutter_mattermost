# Create user's sidebar category

Original OpenAPI operationId: `CreateSidebarCategoryForTeamForUser`
- Method: `POST`
- Path: `/api/v4/users/{user_id}/teams/{team_id}/channels/categories`
- Summary: Create user's sidebar category
- Description: Create a custom sidebar category for the user on the given team.
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
  - `application/json` -> SidebarCategory

## Responses
- `200`: Category creation successful
  - `application/json` -> SidebarCategory
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
