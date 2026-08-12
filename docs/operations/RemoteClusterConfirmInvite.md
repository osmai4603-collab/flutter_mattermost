# Confirm an invite with a remote cluster.

Original OpenAPI operationId: `RemoteClusterConfirmInvite`
- Method: `POST`
- Path: `/api/v4/remotecluster/confirm_invite`
- Summary: Confirm an invite with a remote cluster.
- Description: Confirms an invitation handshake from a linked remote cluster.
This endpoint is authenticated with a remote-cluster token and is
used by the secure connection protocol.

##### Permissions
No user session permissions required.

- Tags: remote clusters

## Parameters
No parameters.

## Request body
- required: False
- content:
  - `application/json` -> RemoteClusterFrame

## Responses
- `200`: Invitation confirmation successful
- `400`: No description available.
- `401`: No description available.
