# Create a new remote cluster.

Original OpenAPI operationId: `CreateRemoteCluster`
- Method: `POST`
- Path: `/api/v4/remotecluster`
- Summary: Create a new remote cluster.
- Description: Create a new remote cluster and generate an invite code.

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
- `201`: Remote cluster creation successful
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
