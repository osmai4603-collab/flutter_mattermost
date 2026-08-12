# Get all channel members from all teams for a user

Original OpenAPI operationId: `GetChannelMembersWithTeamDataForUser`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/channel_members`
- Summary: Get all channel members from all teams for a user
- Description: Get all channel members from all teams for a user.

__Minimum server version__: 6.2.0

##### Permissions
Logged in as the user, or have `edit_other_users` permission.

- Tags: users

## Parameters
- `user_id` (path, required, string) - The ID of the user. This can also be "me" which will point to the current user.
- `page` (query, optional, integer) - Page specifies which part of the results to return, by perPage.
- `per_page` (query, optional, integer) - The size of the returned chunk of results.

## Request body
No request body.

## Responses
- `200`: User's uploads retrieval successful
  - `application/json` -> array of ChannelMemberWithTeamData
- `400`: No description available.
- `401`: No description available.
- `404`: No description available.
