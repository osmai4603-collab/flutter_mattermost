# Get a channel

Original OpenAPI operationId: `GetChannel`
- Method: `GET`
- Path: `/api/v4/channels/{channel_id}`
- Summary: Get a channel
- Description: Get channel from the provided channel id string.
##### Permissions
`read_channel` permission for the channel.

- Tags: channels

## Parameters
- `channel_id` (path, required, string) - Channel GUID

## Request body
No request body.

## Responses
- `200`: Channel retrieval successful
  - `application/json` -> Channel
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
