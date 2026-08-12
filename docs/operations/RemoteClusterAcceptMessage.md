# Receive a remote cluster message.

Original OpenAPI operationId: `RemoteClusterAcceptMessage`
- Method: `POST`
- Path: `/api/v4/remotecluster/msg`
- Summary: Receive a remote cluster message.
- Description: Receives and processes an incoming transport message from a linked
remote cluster. This endpoint is authenticated with a remote-cluster
token and is part of the secure connection protocol.

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
- `200`: Message accepted successfully
  - `application/json` -> RemoteClusterResponse
- `400`: No description available.
- `401`: No description available.
