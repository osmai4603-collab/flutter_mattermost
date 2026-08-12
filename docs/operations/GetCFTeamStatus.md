# Get content flagging status for a team

Original OpenAPI operationId: `GetCFTeamStatus`
- Method: `GET`
- Path: `/api/v4/content_flagging/team/{team_id}/status`
- Summary: Get content flagging status for a team
- Description: Returns the content flagging status for a specific team, indicating whether content flagging is enabled on the specified team or not.
An enterprise advanced license is required.

- Tags: Content Flagging

## Parameters
- `team_id` (path, required, string) - The ID of the team to retrieve the content flagging status for

## Request body
No request body.

## Responses
- `200`: Content flagging status retrieved successfully
  - `application/json` -> object
- `403`: Forbidden - User does not have permission to access this team.
- `404`: The specified team was not found or the feature is disabled via the feature flag.
- `500`: Internal server error.
- `501`: Feature is disabled either via config or an Enterprise Advanced license is not available.
