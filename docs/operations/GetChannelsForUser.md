# Get all channels from all teams

Original OpenAPI operationId: `GetChannelsForUser`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/channels`
- Summary: Get all channels from all teams
- Description: Get all channels from all teams that a user is a member of.

__Minimum server version__: 6.1

##### Permissions

Logged in as the user, or have `edit_other_users` permission.

- Tags: channels

## Parameters
- `user_id` (path, required, string) - The ID of the user. This can also be "me" which will point to the current user.
- `last_delete_at` (query, optional, integer) - Filters the deleted channels by this time in epoch format. Does not have any effect if include_deleted is set to false.
- `include_deleted` (query, optional, boolean) - Defines if deleted channels should be returned or not

## Request body
No request body.

## Responses
- `200`: Channels retrieval successful
  - `application/json` -> array of Channel
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
