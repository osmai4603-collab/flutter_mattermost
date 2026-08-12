# Uninvites a remote cluster to a channel.

Original OpenAPI operationId: `UninviteRemoteClusterToChannel`
- Method: `POST`
- Path: `/api/v4/remotecluster/{remote_id}/channels/{channel_id}/uninvite`
- Summary: Uninvites a remote cluster to a channel.
- Description: Stops sharing a channel with a remote cluster. If the channel
was not shared with the remote, calling this endpoint will
have no effect.

##### Permissions
`manage_shared_channels`

- Tags: shared channels

## Parameters
- `remote_id` (path, required, string) - The remote cluster GUID
- `channel_id` (path, required, string) - The channel GUID to uninvite the remote cluster to

## Request body
No request body.

## Responses
- `200`: Remote cluster uninvited successfully
  - `application/json` -> StatusOK
- `204`: Channel was not shared with the remote cluster. No action needed.
- `401`: No description available.
- `403`: No description available.
