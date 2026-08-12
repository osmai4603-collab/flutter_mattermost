# Search for team posts

Original OpenAPI operationId: `SearchPosts`
- Method: `POST`
- Path: `/api/v4/teams/{team_id}/posts/search`
- Summary: Search for team posts
- Description: Search posts in the team and from the provided terms string.
##### Permissions
Must be authenticated and have the `view_team` permission.

- Tags: posts

## Parameters
- `team_id` (path, required, string) - Team GUID

## Request body
- required: True
- description: The search terms and logic to use in the search.
- content:
  - `application/json` -> object

## Responses
- `200`: Post list retrieval successful
  - `application/json` -> PostListWithSearchMatches
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
