# Get a remote cluster.

Original OpenAPI operationId: `GetRemoteCluster`
- Method: `GET`
- Path: `/api/v4/remotecluster/{remote_id}`
- Summary: Get a remote cluster.
- Description: Get the Remote Cluster details from the provided id string.

##### Permissions
`manage_secure_connections` or `manage_shared_channels`

- Tags: remote clusters

## Parameters
- `remote_id` (path, required, string) - Remote Cluster GUID

## Request body
No request body.

## Responses
- `200`: Remote Cluster retrieval successful
  - `application/json` -> RemoteCluster
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
