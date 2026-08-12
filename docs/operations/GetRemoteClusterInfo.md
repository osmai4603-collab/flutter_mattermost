# Get remote cluster info by ID for user.

Original OpenAPI operationId: `GetRemoteClusterInfo`
- Method: `GET`
- Path: `/api/v4/sharedchannels/remote_info/{remote_id}`
- Summary: Get remote cluster info by ID for user.
- Description: Get remote cluster info based on remoteId.

__Minimum server version__: 5.50

##### Permissions
Must be authenticated and user must belong to at least one channel shared with the remote cluster.

- Tags: shared channels

## Parameters
- `remote_id` (path, required, string) - Remote Cluster GUID
- `include_deleted` (query, optional, boolean) - Include deleted remote clusters

## Request body
No request body.

## Responses
- `200`: Remote cluster info retrieval successful
  - `application/json` -> RemoteClusterInfo
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
