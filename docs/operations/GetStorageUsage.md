# Get the total file storage usage for the instance in bytes.

Original OpenAPI operationId: `GetStorageUsage`
- Method: `GET`
- Path: `/api/v4/usage/storage`
- Summary: Get the total file storage usage for the instance in bytes.
- Description: Get the total file storage usage for the instance in bytes rounded down to the most significant digit. Example: returns 4000 instead of 4321
##### Permissions
Must be authenticated.
__Minimum server version__: 7.1

- Tags: usage

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: The total file storage usage for the instance in bytes rounded down to the most significant digit.
  - `application/json` -> StorageUsage
- `401`: No description available.
- `500`: No description available.
