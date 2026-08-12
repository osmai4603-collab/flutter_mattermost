# Upload file data for a remote upload session.

Original OpenAPI operationId: `UploadRemoteClusterData`
- Method: `POST`
- Path: `/api/v4/remotecluster/upload/{upload_id}`
- Summary: Upload file data for a remote upload session.
- Description: Streams file data into an existing upload session from a linked
remote cluster. This endpoint is authenticated with a remote-cluster token.

##### Permissions
No user session permissions required.

- Tags: remote clusters

## Parameters
- `upload_id` (path, required, string) - The upload session ID.

## Request body
- required: False
- content:
  - `application/octet-stream` -> string
  - `multipart/form-data` -> object

## Responses
- `200`: Upload chunk accepted
  - `application/json` -> FileInfo
- `204`: Upload data accepted with no file completion yet
- `400`: No description available.
- `401`: No description available.
