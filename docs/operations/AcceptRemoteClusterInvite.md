# Accept a remote cluster invite code.

Original OpenAPI operationId: `AcceptRemoteClusterInvite`
- Method: `POST`
- Path: `/api/v4/remotecluster/accept_invite`
- Summary: Accept a remote cluster invite code.
- Description: Accepts a remote cluster invite code.

##### Permissions
`manage_secure_connections`

- Tags: remote clusters

## Parameters
No parameters.

## Request body
- required: False
- content:
  - `application/json` -> object

## Responses
- `201`: Invite successfully accepted
  - `application/json` -> RemoteCluster
- `401`: No description available.
- `403`: No description available.
