# Create a presigned URL for export download

Original OpenAPI operationId: `PresignExport`
- Method: `POST`
- Path: `/api/v4/exports/{export_name}/presign-url`
- Summary: Create a presigned URL for export download
- Description: Creates a presigned URL for downloading an export file.

__Minimum server version__: 5.33

##### Permissions
Must have `manage_system` permission.

- Tags: exports

## Parameters
- `export_name` (path, required, string) - The name of the export file

## Request body
No request body.

## Responses
- `200`: Presigned URL created successfully
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `500`: No description available.
