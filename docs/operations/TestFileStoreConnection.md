# Test the configured file storage backend

Original OpenAPI operationId: `TestFileStoreConnection`
- Method: `POST`
- Path: `/api/v4/file/test`
- Summary: Test the configured file storage backend
- Description: Send a test to validate that the server can connect to the configured file storage backend (local, Amazon S3, or Azure Blob Storage). Optionally provide a configuration in the request body to test. If no valid configuration is present in the request body the current server configuration will be tested.
##### Permissions
Must have `manage_system` permission.
__Minimum server version__: 11.10

- Tags: system

## Parameters
No parameters.

## Request body
- required: False
- description: Mattermost configuration
- content:
  - `application/json` -> Config

## Responses
- `200`: File storage test successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `403`: No description available.
- `500`: No description available.
