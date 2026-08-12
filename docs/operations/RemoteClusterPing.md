# Receive a ping from a remote cluster.

Original OpenAPI operationId: `RemoteClusterPing`
- Method: `POST`
- Path: `/api/v4/remotecluster/ping`
- Summary: Receive a ping from a remote cluster.
- Description: Receives heartbeat traffic from an already linked remote cluster.
This endpoint is authenticated with a remote-cluster token and is
used by the secure connection transport layer.

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
- `200`: Ping response successful
  - `application/json` -> RemoteClusterPing
- `400`: No description available.
- `401`: No description available.
