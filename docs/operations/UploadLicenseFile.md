# Upload license file

Original OpenAPI operationId: `UploadLicenseFile`
- Method: `POST`
- Path: `/api/v4/license`
- Summary: Upload license file
- Description: Upload a license to enable enterprise features.

__Minimum server version__: 4.0

##### Permissions
Must have `manage_system` permission.

- Tags: system

## Parameters
No parameters.

## Request body
- required: False
- content:
  - `multipart/form-data` -> object

## Responses
- `201`: License file upload successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `413`: No description available.
