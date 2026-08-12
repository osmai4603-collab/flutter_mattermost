# Gets all scheduled posts for a user for the specified team..

Original OpenAPI operationId: `GetUserScheduledPosts`
- Method: `GET`
- Path: `/api/v4/posts/scheduled/team/{team_id}`
- Summary: Gets all scheduled posts for a user for the specified team..
- Description: Get user-team scheduled posts
##### Permissions
Must have `view_team` permission for the team the scheduled posts are being fetched for.
__Minimum server version__: 10.3

- Tags: scheduled_post

## Parameters
- `includeDirectChannels` (query, optional, boolean) - Whether to include scheduled posts from DMs an GMs or not. Default is false

## Request body
No request body.

## Responses
- `200`: Created scheduled post
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
