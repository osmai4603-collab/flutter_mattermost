# Search posts across all teams

Original OpenAPI operationId: `SearchPostsInAllTeams`
- Method: `POST`
- Path: `/api/v4/posts/search`
- Summary: Search posts across all teams
- Description: Search posts visible to the current user across all teams.
##### Permissions
Must be authenticated.

- Tags: posts

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Post search successful
  - `application/json` -> PostListWithSearchMatches
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
