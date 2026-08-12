# Get channels for user

Original OpenAPI operationId: `GetChannelsForTeamForUser`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/teams/{team_id}/channels`
- Summary: Get channels for user
- Description: Get all the channels on a team for a user.
##### Permissions
Logged in as the user, or have `edit_other_users` permission, and `view_team` permission for the team.

- Tags: channels

## Parameters
- `user_id` (path, required, string) - User GUID
- `team_id` (path, required, string) - Team GUID
- `include_deleted` (query, optional, boolean) - Defines if deleted channels should be returned or not
- `last_delete_at` (query, optional, integer) - Filters the deleted channels by this time in epoch format. Does not have any effect if include_deleted is set to false.

## Request body
No request body.

## Responses
- `200`: Channels retrieval successful
  - `application/json` -> array of Channel
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
