# Get remote clusters for a shared channel

Original OpenAPI operationId: `GetSharedChannelRemotes`
- Method: `GET`
- Path: `/api/v4/sharedchannels/{channel_id}/remotes`
- Summary: Get remote clusters for a shared channel
- Description: Gets the remote clusters information for a shared channel.

__Minimum server version__: 10.11

##### Permissions
Must be authenticated and have the `read_channel` permission for the channel.

- Tags: shared channels

## Parameters
- `channel_id` (path, required, string) - Channel GUID

## Request body
No request body.

## Responses
- `200`: Remote clusters retrieval successful
  - `application/json` -> array of RemoteClusterInfo
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
