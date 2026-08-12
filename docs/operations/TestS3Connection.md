# Test AWS S3 connection

Original OpenAPI operationId: `TestS3Connection`
- Method: `POST`
- Path: `/api/v4/file/s3_test`
- Summary: Test AWS S3 connection
- Description: Deprecated alias for `/api/v4/file/test` kept for backwards compatibility. New callers should use `/api/v4/file/test`, which is backend-agnostic.
##### Permissions
Must have `manage_system` permission.
__Minimum server version__: 4.8

- Tags: system
- Deprecated: True

## Parameters
No parameters.

## Request body
- required: True
- description: Mattermost configuration
- content:
  - `application/json` -> Config

## Responses
- `200`: S3 Test successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `403`: No description available.
- `500`: No description available.
