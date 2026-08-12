# Get a channel by name

Original OpenAPI operationId: `GetChannelByName`
- Method: `GET`
- Path: `/api/v4/teams/{team_id}/channels/name/{channel_name}`
- Summary: Get a channel by name
- Description: Gets channel from the provided team id and channel name strings.
##### Permissions
`read_channel` permission for the channel.

- Tags: channels

## Parameters
- `team_id` (path, required, string) - Team GUID
- `channel_name` (path, required, string) - Channel Name
- `include_deleted` (query, optional, boolean) - Defines if deleted channels should be returned or not (Mattermost Server 5.26.0+)

## Request body
No request body.

## Responses
- `200`: Channel retrieval successful
  - `application/json` -> Channel
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
