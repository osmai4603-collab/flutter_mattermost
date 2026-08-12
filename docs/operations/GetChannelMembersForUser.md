# Get channel memberships and roles for a user

Original OpenAPI operationId: `GetChannelMembersForUser`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/teams/{team_id}/channels/members`
- Summary: Get channel memberships and roles for a user
- Description: Get all channel memberships and associated membership roles (i.e. `channel_user`, `channel_admin`) for a user on a specific team.
##### Permissions
Logged in as the user and `view_team` permission for the team. Having `manage_system` permission voids the previous requirements.

- Tags: channels

## Parameters
- `user_id` (path, required, string) - User GUID
- `team_id` (path, required, string) - Team GUID

## Request body
No request body.

## Responses
- `200`: Channel members retrieval successful
  - `application/json` -> array of ChannelMember
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
