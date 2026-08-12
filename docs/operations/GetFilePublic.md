# Get a public file

Original OpenAPI operationId: `GetFilePublic`
- Method: `GET`
- Path: `/files/{file_id}/public`
- Summary: Get a public file
- Description: ##### Permissions
No permissions required.

- Tags: files

## Parameters
- `file_id` (path, required, string) - The ID of the file to get
- `h` (query, required, string) - File hash

## Request body
No request body.

## Responses
- `400`: No description available.
- `401`: No description available.
- `403`: Do not have appropriate permissions
  - `application/json` -> AppError
- `404`: No description available.
- `501`: No description available.
