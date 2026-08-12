# Patch a remote cluster.

Original OpenAPI operationId: `PatchRemoteCluster`
- Method: `PATCH`
- Path: `/api/v4/remotecluster/{remote_id}`
- Summary: Patch a remote cluster.
- Description: Partially update a Remote Cluster by providing only the fields you want to update. Ommited fields will not be updated.

##### Permissions
`manage_secure_connections`

- Tags: remote clusters

## Parameters
- `remote_id` (path, required, string) - Remote Cluster GUID

## Request body
- required: False
- content:
  - `application/json` -> object

## Responses
- `200`: Remote Cluster patch successful
  - `application/json` -> RemoteCluster
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
