# Generate invite code.

Original OpenAPI operationId: `GenerateRemoteClusterInvite`
- Method: `POST`
- Path: `/api/v4/remotecluster/{remote_id}/generate_invite`
- Summary: Generate invite code.
- Description: Generates an invite code for a given remote cluster.

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
- `201`: Invite code generated
  - `application/json` -> string
- `401`: No description available.
- `403`: No description available.
