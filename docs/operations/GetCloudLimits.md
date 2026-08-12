# Get cloud workspace limits

Original OpenAPI operationId: `GetCloudLimits`
- Method: `GET`
- Path: `/api/v4/cloud/limits`
- Summary: Get cloud workspace limits
- Description: Retrieve any cloud workspace limits applicable to this instance.
##### Permissions
Must be authenticated and be licensed for Cloud.
__Minimum server version__: 7.0 __Note:__ This is intended for internal use and is subject to change.

- Tags: cloud

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Cloud workspace limits returned successfully
  - `application/json` -> ProductLimits
- `401`: No description available.
- `500`: No description available.
- `501`: No description available.
