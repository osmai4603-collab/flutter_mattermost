# Invites a remote cluster to a channel.

Original OpenAPI operationId: `InviteRemoteClusterToChannel`
- Method: `POST`
- Path: `/api/v4/remotecluster/{remote_id}/channels/{channel_id}/invite`
- Summary: Invites a remote cluster to a channel.
- Description: Invites a remote cluster to a channel, sharing the channel if
needed. If the remote cluster was already invited to the
channel, calling this endpoint will have no effect.

##### Permissions
`manage_shared_channels`

- Tags: shared channels

## Parameters
- `remote_id` (path, required, string) - The remote cluster GUID
- `channel_id` (path, required, string) - The channel GUID to invite the remote cluster to

## Request body
No request body.

## Responses
- `200`: Remote cluster invited successfully
  - `application/json` -> StatusOK
- `401`: No description available.
- `403`: No description available.
