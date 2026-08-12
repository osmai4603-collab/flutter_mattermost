# Remove license file

Original OpenAPI operationId: `RemoveLicenseFile`
- Method: `DELETE`
- Path: `/api/v4/license`
- Summary: Remove license file
- Description: Remove the license file from the server. This will disable all enterprise features.

__Minimum server version__: 4.0

##### Permissions
Must have `manage_system` permission.

- Tags: system

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: License removal successful
- `401`: No description available.
- `403`: No description available.
