# Search content reviewers in a team

Original OpenAPI operationId: `SearchCFTeamReviewers`
- Method: `GET`
- Path: `/api/v4/content_flagging/team/{team_id}/reviewers/search`
- Summary: Search content reviewers in a team
- Description: Searches for content reviewers of a specific team based on a provided term. Only a content reviewer can access this endpoint.

An enterprise advanced license is required.

- Tags: Content Flagging

## Parameters
- `team_id` (path, required, string) - The ID of the team to search for content reviewers for
- `term` (query, required, string) - The search term to filter content reviewers by

## Request body
No request body.

## Responses
- `200`: Content reviewers retrieved successfully
  - `application/json` -> array of User
- `403`: Forbidden - User does not have permission to access this team.
- `404`: The specified team was not found or the feature is disabled via the feature flag.
- `500`: Internal server error.
- `501`: Feature is disabled either via config or an Enterprise Advanced license is not available.
