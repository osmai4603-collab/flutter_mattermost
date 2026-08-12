# Restore a channel

Original OpenAPI operationId: `RestoreChannel`
- Method: `POST`
- Path: `/api/v4/channels/{channel_id}/restore`
- Summary: Restore a channel
- Description: Restore channel from the provided channel id string.

__Minimum server version__: 3.10

##### Permissions
`manage_team` permission for the team of the channel.

- Tags: channels

## Parameters
- `channel_id` (path, required, string) - Channel GUID

## Request body
No request body.

## Responses
- `200`: Channel restore successful
  - `application/json` -> Channel
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
