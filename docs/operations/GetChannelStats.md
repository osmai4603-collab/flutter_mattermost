# Get channel statistics

Original OpenAPI operationId: `GetChannelStats`
- Method: `GET`
- Path: `/api/v4/channels/{channel_id}/stats`
- Summary: Get channel statistics
- Description: Get statistics for a channel.
##### Permissions
Must have the `read_channel` permission.

- Tags: channels

## Parameters
- `channel_id` (path, required, string) - Channel GUID

## Request body
No request body.

## Responses
- `200`: Channel statistics retrieval successful
  - `application/json` -> ChannelStats
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
