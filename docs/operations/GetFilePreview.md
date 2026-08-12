# Get a file's preview

Original OpenAPI operationId: `GetFilePreview`
- Method: `GET`
- Path: `/api/v4/files/{file_id}/preview`
- Summary: Get a file's preview
- Description: Gets a file's preview.
##### Permissions
Must have `read_channel` permission or be uploader of the file.

- Tags: files

## Parameters
- `file_id` (path, required, string) - The ID of the file to get

## Request body
No request body.

## Responses
- `400`: No description available.
- `401`: No description available.
- `403`: Do not have appropriate permissions
  - `application/json` -> AppError
- `404`: No description available.
- `501`: No description available.
