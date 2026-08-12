# Get metadata for a file

Original OpenAPI operationId: `GetFileInfo`
- Method: `GET`
- Path: `/api/v4/files/{file_id}/info`
- Summary: Get metadata for a file
- Description: Gets a file's info.
##### Permissions
Must have `read_channel` permission or be uploader of the file.

- Tags: files

## Parameters
- `file_id` (path, required, string) - The ID of the file info to get

## Request body
No request body.

## Responses
- `200`: The stored metadata for the given file
  - `application/json` -> FileInfo
- `400`: No description available.
- `401`: No description available.
- `403`: Do not have appropriate permissions
  - `application/json` -> AppError
- `404`: No description available.
- `501`: No description available.
