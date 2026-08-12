# Get cluster status

Original OpenAPI operationId: `GetClusterStatus`
- Method: `GET`
- Path: `/api/v4/cluster/status`
- Summary: Get cluster status
- Description: Get a list of all healthy nodes, including local information and status of each one. If a node is not present, it means it is not healthy.
##### Permissions
Must have `manage_system` permission.

- Tags: cluster

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Cluster status retrieval successful
  - `application/json` -> array of ClusterInfo
- `403`: No description available.
