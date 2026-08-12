# Get a list of flagged posts

Original OpenAPI operationId: `GetFlaggedPostsForUser`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/posts/flagged`
- Summary: Get a list of flagged posts
- Description: Get a page of flagged posts of a user provided user id string. Selects from a channel, team, or all flagged posts by a user. Will only return posts from channels in which the user is member.
##### Permissions
Must be user or have `manage_system` permission.

- Tags: posts

## Parameters
- `user_id` (path, required, string) - ID of the user
- `team_id` (query, optional, string) - Team ID
- `channel_id` (query, optional, string) - Channel ID
- `page` (query, optional, integer) - The page to select
- `per_page` (query, optional, integer) - The number of posts per page

## Request body
No request body.

## Responses
- `200`: Post list retrieval successful
  - `application/json` -> array of PostList
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
