# Create an upload

Original OpenAPI operationId: `CreateUpload`
- Method: `POST`
- Path: `/api/v4/uploads`
- Summary: Create an upload
- Description: Creates a new upload session.

__Minimum server version__: 5.28
##### Permissions
Must have `upload_file` permission.

- Tags: uploads

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `201`: Upload creation successful.
  - `application/json` -> UploadSession
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `413`: No description available.
- `501`: No description available.
