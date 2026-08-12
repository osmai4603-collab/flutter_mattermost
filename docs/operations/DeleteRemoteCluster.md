# Delete a remote cluster.

Original OpenAPI operationId: `DeleteRemoteCluster`
- Method: `DELETE`
- Path: `/api/v4/remotecluster/{remote_id}`
- Summary: Delete a remote cluster.
- Description: Deletes a Remote Cluster.

##### Permissions
`manage_secure_connections`

- Tags: remote clusters

## Parameters
- `remote_id` (path, required, string) - Remote Cluster GUID

## Request body
No request body.

## Responses
- `204`: Remote Cluster deletion successful
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
