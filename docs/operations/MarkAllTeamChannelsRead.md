# Mark all channels and threads in a team as read

Original OpenAPI operationId: `MarkAllTeamChannelsRead`
- Method: `PUT`
- Path: `/api/v4/users/{user_id}/teams/{team_id}/read`
- Summary: Mark all channels and threads in a team as read
- Description: Mark all channels and threads in a team as read for a user.

##### Permissions

Must be logged in as user or have `edit_other_users` permission. Must have `view_team` permission for the team.

__Minimum server version__: 11.3

- Tags: channels

## Parameters
- `user_id` (path, required, string) - User ID to mark channels as read for
- `team_id` (path, required, string) - Team ID to mark all channels as read in

## Request body
No request body.

## Responses
- `200`: Team channels marked as read successfully
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
