# Get common teams for members of a Group Message.

Original OpenAPI operationId: `GetGroupMessageMembersCommonTeams`
- Method: `GET`
- Path: `/api/v4/channels/{channel_id}/common_teams`
- Summary: Get common teams for members of a Group Message.
- Description: Gets all the common teams for all active members of a Group Message channel.
Returns empty list of no common teams are found.

__Minimum server version__: 9.1

##### Permissions
Must be authenticated and have the `read_channel` permission for the channel.

- Tags: channels, group message

## Parameters
- `channel_id` (path, required, string) - Channel GUID

## Request body
No request body.

## Responses
- `200`: Common teams retrieval successful
  - `application/json` -> array of Team
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
